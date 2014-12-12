#include "manager.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlRecord>
#include <QtSql/QSqlError>
#include <QDebug>
#include <QDateTime>

enum Manager::Timing : int {LATE, EARLY, ON_TIME};

Manager::Manager(QObject *parent) : QObject(parent),
    m_active(0), m_scheduled(0), m_unmemorized(0)
{
    m_nemo = QSqlDatabase::addDatabase("QSQLITE");
    m_nemo.setHostName("localhost");
}

bool Manager::isValidDb(QString filePath) {
    //Step 1: Check if this is an sql lite db
    if(m_nemo.isOpen()) m_nemo.close();

    qDebug() << "opening db at " << filePath;
    m_nemo.setDatabaseName(filePath);
    if(!m_nemo.open())return false;

    qDebug() << "running query on " << m_nemo;
    //Step 2: Check for a mnemosyne table for verification
    QSqlQuery query("SELECT * FROM global_variables WHERE key='version' AND value='Mnemosyne SQL 1.0';", m_nemo);
    if(!query.exec()) {
        qDebug() << query.lastError().text();
        return false;
    }

    qDebug() << "query was valid ";

    bool result = query.record().indexOf("value") != -1;
    if(result) initTrackingValues();

    return result;
}

void Manager::initTrackingValues() {
    if(!m_nemo.isOpen()) return;

    //scheduled
    QSqlQuery query = QSqlQuery("SELECT count(*) AS count FROM cards WHERE grade>=2 AND CURRENT_TIMESTAMP>=next_rep AND active=1;", m_nemo);
    if(!query.exec() || query.record().indexOf("count") == -1) {
        qDebug() << "initTracking" << query.lastError().text();
        return;
    }
    query.first();

    qDebug() << "initTracking" << query.record();
    setScheduled(query.value("count").toInt());

    //active
    query = QSqlQuery("SELECT count(*) AS count FROM cards WHERE active=1;", m_nemo);
    if(!query.exec() || query.record().indexOf("count") == -1) {
        qDebug() << "initTracking" << query.lastError().text();
        return;
    }
    query.first();

    qDebug() << "initTracking" << query.record();
    setActive(query.value("count").toInt());

    //unmemorized
    query = QSqlQuery("SELECT count(*) AS count FROM cards WHERE grade < 2 AND active=1;", m_nemo);
    if(!query.exec() || query.record().indexOf("count") == -1) {
        qDebug() << "initTracking" << query.lastError().text();
        return;
    }
    query.first();

    qDebug() << "initTracking" << query.record();
    setUnmemorized(query.value("count").toInt());
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
    if(!m_nemo.isOpen()) return nullptr;

    QSqlQuery query = QSqlQuery("SELECT question,answer FROM cards WHERE grade>=2 " \
                                "AND CURRENT_TIMESTAMP>=next_rep AND active=1 " \
                                "ORDER BY next_rep DESC LIMIT 1;", m_nemo);
    if(!query.exec()) {
        qDebug() << "next:" << "memory stack" << query.lastError().text();
        return nullptr;
    }

    query.first();

    if(!query.isValid()) {
        //Pull card from unmemorized pool
        query = QSqlQuery("SELECT question,answer FROM cards WHERE grade < 2 AND active=1 " \
                          "ORDER BY next_rep DESC LIMIT 1;", m_nemo);
        if(!query.exec()) {
            qDebug() << "next:" << "unmemorized stack" << query.lastError().text();
            return nullptr;
        }
    }

    if(!query.isValid()) {
        //Last attempt: pull card from the reviewed stack, longest rep first
        query = QSqlQuery("SELECT question,answer FROM cards WHERE active=1 " \
                          "ORDER BY next_rep ASC LIMIT 1;", m_nemo);
        if(!query.exec()) {
            qDebug() << "next:" << "reviewed stack" << query.lastError().text();
            return nullptr;
        }
    }

    qDebug() << "next" << query.record();
    if(m_currentCard != nullptr) {
        grade(rating);
        m_currentCard->deleteLater();
    }

    m_currentCard = new Card(this);
    m_currentCard->setQuestion(query.value("question").toString());
    m_currentCard->setAnswer(query.value("answer").toString());
    m_currentCard->setNextRep(query.value("next_rep").toLongLong());
    m_currentCard->setGrade(query.value("grade").toInt());
    m_currentCard->setEasiness(query.value("easiness"));
    m_currentCard->setAcquisitionReps(query.value("acq_reps"));
    m_currentCard->setAcquisitionRepsSinceLast(query.value("acq_reps_since_lapse"));
    return m_currentCard;
}

/*!
 Mnemosyne 2.3 keeps track of "facts" which seem to be a table that contains
 memorized cards. One purpose is to avoid pulling in sister cards in the schedule.
 This class will ignore facts for simplicity; although, I'm not sure how this
 will Mnemosyne proper when shuffling the database.
 */
void Manager::grade(int rating) {
    // First calculate timing
    qint64 tstamp = QDateTime::currentDateTimeUtc().toMSecsSinceEpoch();
    int timing = Timing::LATE;
    if(tstamp - 1000*60*60*24 < m_currentCard->nextRep()) {
        timing = tstamp < m_currentCard->nextRep() ? Timing::EARLY : Timing::ON_TIME;
    }

    //Get last seen interval
    qint64 interval = m_currentCard->nextRep() - m_currentCard->lastRep();

    int oldGrade = m_currentCard->grade();
    if(oldGrade < 1) {
        interval = 0; //Ignore for unmemorized cards
    }

    if(oldGrade == -1) {

    }
}
