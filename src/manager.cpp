#include "manager.h"

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlRecord>
#include <QtSql/QSqlError>
#include <QDebug>

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

Card* Manager::next(int rating) {
    if(!m_nemo.isOpen()) return nullptr;

    QSqlQuery query = QSqlQuery("SELECT question,answer FROM cards WHERE grade>=2 " \
                                "AND CURRENT_TIMESTAMP>=next_rep AND active=1 " \
                                "ORDER BY next_rep DESC LIMIT 1;", m_nemo);
    if(!query.exec()) {
        qDebug() << "next" << query.lastError().text();
        return nullptr;
    }
    query.first();

    qDebug() << "next" << query.record();
    m_currentCard->deleteLater();
    m_currentCard = new Card(this);
    m_currentCard->setQuestion(query.value("question").toString());
    m_currentCard->setAnswer(query.value("answer").toString());
    return m_currentCard;
}
