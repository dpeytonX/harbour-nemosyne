#include "manager.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlRecord>
#include <QtSql/QSqlError>
#include <QDebug>
#include <QDateTime>
#include <QFile>
#include <QDir>

#include <stdlib.h>

enum Manager::Timing : int {LATE, EARLY, ON_TIME};

Manager::Manager(QObject *parent) : QObject(parent),
    m_active(0), m_scheduled(0), m_unmemorized(0), m_database(this), m_currentCard(nullptr)
{
    m_nemo = m_database.database();
}

bool Manager::isValidDb(QString filePath) {
    //Step 1: Check if this is an sql lite db
    if(m_database.opened()) m_database.close();

    qDebug() << "opening db at " << filePath;
    m_database.setDatabaseName(filePath);
    if(!m_database.open())return false;

    qDebug() << "running query on " << m_database.database();
    //Step 2: Check for a mnemosyne table for verification

    bool exec = m_database.exec("SELECT * FROM global_variables WHERE key='version' AND value='Mnemosyne SQL 1.0';");
    QSqlQuery query = m_database.lastQuery();
    if(!exec) {
        qDebug() << query.lastError().text();
        return false;
    }

    qDebug() << "query was valid ";

    bool result = query.record().indexOf("value") != -1;
    if(result) initTrackingValues();

    return result;
}

bool Manager::create(QString filePath) {
    return m_database.create(filePath);
}

bool Manager::initialize() {
    QFile sql(":/data/nemosyne.sql");

    if(!sql.exists()) {
        qDebug() << "initialize: resource does not exist!";
        return false;
    }

    sql.open(QIODevice::ReadOnly);
    QStringList command = QTextStream(&sql).readAll().split(';');

    //Qt SQLite driver can only execute one statement at a time.
    foreach(QString c, command) {
        if(c.trimmed().isEmpty()) continue;
        c.append(';');
        bool result = m_database.exec(c);
        if(!result) {
            qDebug() << "initialize: error occurred " << c << m_database.lastQuery().lastError();
        }
    }
    return true;
}

void Manager::initTrackingValues() {
    if(!m_database.opened()) return;

    //scheduled
    bool result = m_database.exec("SELECT count(*) AS count FROM cards WHERE grade >= 2 AND strftime('%s',datetime('now', 'start of day', '-1 day'))>=next_rep AND active=1;");
    QSqlQuery query = m_database.lastQuery();
    if(!result || query.record().indexOf("count") == -1) {
        qDebug() << "initTracking" << query.lastError().text();
        return;
    }
    query.first();

    qDebug() << "initTracking" << query.record();
    setScheduled(query.value("count").toInt());

    //active
    result = m_database.exec("SELECT count(*) AS count FROM cards WHERE active=1;");
    query = m_database.lastQuery();
    if(!result || query.record().indexOf("count") == -1) {
        qDebug() << "initTracking" << query.lastError().text();
        return;
    }
    query.first();

    qDebug() << "initTracking" << query.record();
    setActive(query.value("count").toInt());

    //unmemorized
    result = m_database.exec("SELECT count(*) AS count FROM cards WHERE grade < 2 AND active=1;");
    query = m_database.lastQuery();

    if(!result || query.record().indexOf("count") == -1) {
        qDebug() << "initTracking" << query.lastError().text();
        return;
    }
    query.first();

    qDebug() << "initTracking" << query.record();
    setUnmemorized(query.value("count").toInt());
}

qint64 Manager::calculateInitialInterval(int rating, Timing timing, qint64 actualInterval, qint64 scheduledInterval) {
    qint64 day = 60*60*24;
    qint64 intervals[6] = {0, 0, day, 3 * day, 4 * day, 7 * day};
    qint64 choice3[3] = {1, 1, 2};
    qint64 choice4[3] = {1, 2, 2};

    int oldGrade = m_currentCard->grade();
    qDebug() << "caculate interval: grade " << oldGrade << " new " << rating;

    if(oldGrade == -1)
        return intervals[rating];
    if(oldGrade <= 1 && rating <= 1)
        return 0;
    if(oldGrade <= 1) {
        switch(rating) {
        case 2:
            return day;
        case 3:
            return choice3[rand() % 3] * day;
        case 4:
            return choice4[rand() % 3] * day;
        case 5:
            return 2 * day;
        }
    }

    if(rating <= 1)
        return 0;

    // Card's old grade and rating are > 1
    if(m_currentCard->retentionRepsSinceLast() == 1)
        return 6 * day;

    if(scheduledInterval == 0) scheduledInterval = day;

    if(rating <= 3)
        return (timing == Timing::ON_TIME || timing == Timing::EARLY) ? actualInterval * m_currentCard->easiness() :
                                                                        scheduledInterval;

    if(rating == 4) return actualInterval * m_currentCard->easiness();

    if(rating == 5) return timing == Timing::EARLY ? scheduledInterval : actualInterval * m_currentCard->easiness();

    //I'm ignoring interval noise. Just get the d*** value.
    return day;
}

//TODO: error check if no records returned
//TODO: check card from unmemorized
//TODO: check card from reviewed
//TODO: check nullptr in QML
/*!
  The Mnemosyne 2.3 algorithm is more complex allowing for randomization of
  cards on a stack and avoiding sister cards.

  Until requested otherwise, this algorithm will just stick to the basics.
 */
Card* Manager::next(int rating) {
    qDebug() << "Manager::next";
    if(!m_database.opened() || !m_database.valid()) return nullptr;

    qDebug() << "Rating is " << rating;
    if(m_currentCard != nullptr) {
        qDebug() << "Card is not null";
        if(rating != -1) {
            //If the database was just opened, current card is orphaned.
            grade(rating);
            saveCard();
        }
        delete m_currentCard;
        m_currentCard = nullptr;
    }

    initTrackingValues();

    qDebug() << "searching in graded pool";
    bool result = m_database.exec(QString("SELECT * FROM cards WHERE grade>=2 ") +
                    "AND strftime('%s',datetime('now', 'start of day', '-1 day')) >=next_rep AND active=1 " +
                    "ORDER BY next_rep DESC LIMIT 1;");
    QSqlQuery query = m_database.lastQuery();
    if(!result) {
        qDebug() << "next:" << "memory stack" << query.lastError().text();
        return nullptr;
    }

    query.first();

    if(!query.isValid()) {
        //Pull card from unmemorized pool
        qDebug() << "searching in unmemorized pool";
        result = m_database.exec("SELECT * FROM cards WHERE grade < 2 AND active=1 " \
                          "ORDER BY next_rep DESC LIMIT 1;");
         query = m_database.lastQuery();
        if(!result) {
            qDebug() << "next:" << "unmemorized stack" << query.lastError().text();
            return nullptr;
        }
        query.first();
    }

    if(!query.isValid()) {
        //Last attempt: pull card from the reviewed stack, longest rep first
        qDebug() << "searching in reviewed pool";
        result = m_database.exec("SELECT * FROM cards WHERE active=1 " \
                          "ORDER BY next_rep DESC LIMIT 1;");
         query = m_database.lastQuery();
        if(!result) {
            qDebug() << "next:" << "reviewed stack" << query.lastError().text();
            return nullptr;
        }
        query.first();
    }

    qDebug() << "next" << query.record();
    if(!query.isValid()) return nullptr;

    m_currentCard = new Card(this);
    m_currentCard->setSeq(query.value("_id").toLongLong());
    m_currentCard->setQuestion(query.value("question").toString());
    m_currentCard->setAnswer(query.value("answer").toString());
    m_currentCard->setNextRep(query.value("next_rep").toLongLong());
    m_currentCard->setLastRep(query.value("last_rep").toLongLong());
    m_currentCard->setGrade(query.value("grade").toInt());
    m_currentCard->setEasiness(query.value("easiness").toDouble());
    m_currentCard->setAcquisition(query.value("acq_reps").toInt());
    m_currentCard->setAcquisitionRepsSinceLast(query.value("acq_reps_since_lapse").toInt());
    m_currentCard->setRetentionRep(query.value("ret_reps").toInt());
    m_currentCard->setLapses(query.value("lapses").toInt());
    m_currentCard->setRetentionRepsSinceLast(query.value("ret_reps_since_lapse").toInt());
    return m_currentCard;
}

/*!
 Mnemosyne 2.3 keeps track of "facts" which seem to be a table that contains
 memorized cards. One purpose is to avoid pulling in sister cards in the schedule.
 This class will ignore facts for simplicity; although, I'm not sure how this
 will Mnemosyne proper when shuffling the database.
 */
void Manager::grade(int rating) {
    if(rating == -1) return;

    // First calculate timing
    qint64 tstamp = QDateTime::currentDateTimeUtc().toMSecsSinceEpoch() / 1000;
    qDebug() << "grade: timestamp " << tstamp;
    qDebug() << "grade: nextrep " << m_currentCard->nextRep();
    Timing timing = Timing::LATE;
    if(tstamp - 60*60*24 < m_currentCard->nextRep()) {
        timing = tstamp < m_currentCard->nextRep() ? Timing::EARLY : Timing::ON_TIME;
    }

    //Get last seen interval
    int oldGrade = m_currentCard->grade();
    qint64 interval = m_currentCard->nextRep() - m_currentCard->lastRep();
    qint64 actualInterval = tstamp - m_currentCard->lastRep();
    qDebug() << " actual interval " << actualInterval << "scheduled interval " << interval;
    qint64 intervalNew = calculateInitialInterval(rating, timing, oldGrade < 1 ? 0 : actualInterval, interval);

    // Set acquisition stage
    if(oldGrade == -1) {
        m_currentCard->setEasiness(2.5);
        m_currentCard->setAcquisition(1);
        m_currentCard->setAcquisitionRepsSinceLast(1);
    } else if(oldGrade <= 1 && rating <= 1 ) {
        m_currentCard->setAcquisition(m_currentCard->acquisition() + 1);
        m_currentCard->setAcquisitionRepsSinceLast(m_currentCard->acquisitionRepsSinceLast() + 1);
        intervalNew  = 0;
    } else if(oldGrade <= 1) {
        m_currentCard->setAcquisition(m_currentCard->acquisition() + 1);
        m_currentCard->setAcquisitionRepsSinceLast(m_currentCard->acquisitionRepsSinceLast() + 1);
    } else if (rating <= 1) {
        m_currentCard->setRetentionRep(m_currentCard->retentionRep() + 1);
        m_currentCard->setLapses(m_currentCard->lapses() + 1);
        m_currentCard->setAcquisition(0);
        m_currentCard->setAcquisitionRepsSinceLast(0);
        m_currentCard->setRetentionRepsSinceLast(0);
    } else {
        double easiness = m_currentCard->easiness();
        m_currentCard->setRetentionRep(m_currentCard->retentionRep() + 1);
        m_currentCard->setRetentionRepsSinceLast(m_currentCard->retentionRepsSinceLast() + 1);
        switch(timing) {
        case Timing::LATE:
        case Timing::ON_TIME:
            if(rating == 2) m_currentCard->setEasiness(easiness - 0.16);
            else if(rating == 3) m_currentCard->setEasiness(easiness - 0.14);
            else if(rating == 5) m_currentCard->setEasiness(easiness + 0.1);
            easiness = m_currentCard->easiness();
            if(easiness < 1.3) m_currentCard->setEasiness(1.3);
            break;
        default:
            break;
        }
    }

    m_currentCard->setGrade(rating);
    m_currentCard->setLastRep(tstamp);

    qDebug() << "grade: old next rep " << m_currentCard->nextRep();
    qDebug() << "grade: interval new " << intervalNew;

    m_currentCard->setNextRep(m_currentCard->lastRep());
    if(rating >= 2) m_currentCard->setNextRep(m_currentCard->lastRep() + intervalNew);

    qDebug() << "grade: new next rep " << m_currentCard->nextRep();

    //Ignoring log entry
}

void Manager::saveCard() {
    if(!m_database.opened() || m_currentCard == nullptr) return;

    qDebug() << "saving card" << m_currentCard->seq();

    m_database.prepare("UPDATE cards SET " \
                  "question = :question, "\
                  "answer = :answer, "\
                  "next_rep = datetime(:next_rep, 'unixepoch'), "\
                  "last_rep = datetime(:last_rep, 'unixepoch'), "\
                  "grade = :grade, "\
                  "easiness = :easiness, "\
                  "acq_reps = :acq_reps, "\
                  "acq_reps_since_lapse = :acq_reps_since_lapse, "\
                  "ret_reps = :ret_reps, "\
                  "lapses = :lapses, "\
                  "ret_reps_since_lapse = :ret_reps_since_lapse "\
                  "WHERE _id = :seq;");

    m_database.bind(":question", m_currentCard->question());
    m_database.bind(":answer", m_currentCard->answer());
    m_database.bind(":next_rep", m_currentCard->nextRep());
    m_database.bind(":last_rep", m_currentCard->lastRep());
    m_database.bind(":grade", m_currentCard->grade());
    m_database.bind(":easiness", m_currentCard->easiness());
    m_database.bind(":acq_reps", m_currentCard->acquisition());
    m_database.bind(":acq_reps_since_lapse", m_currentCard->acquisitionRepsSinceLast());
    m_database.bind(":ret_reps", m_currentCard->retentionRep());
    m_database.bind(":lapses", m_currentCard->lapses());
    m_database.bind(":ret_reps_since_lapse", m_currentCard->retentionRepsSinceLast());
    m_database.bind(":seq", m_currentCard->seq());

    if(!m_database.exec()) {
        qDebug() << "save:" << "error" << m_database.lastQuery().lastError().text();
        return;
    }
}
