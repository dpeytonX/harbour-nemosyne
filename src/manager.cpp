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

    QSqlQuery query("SELECT * FROM cards", m_nemo);
    if(!query.exec()) {
        qDebug() << "initTracking" << query.record();
        qDebug() << "initTracking" << query.lastError().text();
        return;
    }

    //active
    query = QSqlQuery("SELECT count(*) AS count FROM cards WHERE active=1;", m_nemo);
    if(!query.exec() || query.record().indexOf("count") == -1) {
        qDebug() << "initTracking" << query.lastError().text();
        return;
    }

    qDebug() << "initTracking" << query.record();
    setActive(query.record().value("count").toInt());

    //unmemorized
    query = QSqlQuery("SELECT count(*) AS count FROM cards WHERE grade < 2 AND active=1;", m_nemo);
    if(!query.exec() || query.record().indexOf("count") == -1) {
        qDebug() << "initTracking" << query.lastError().text();
        return;
    }

    qDebug() << "initTracking" << query.record();
    setUnmemorized(query.record().value("count").toInt());

}
