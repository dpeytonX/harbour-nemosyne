#include "sqlitedatabase.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QString>

SQLiteDatabase::SQLiteDatabase(QObject *parent) : QObject(parent),
  m_lastQuery()
{
    m_database = QSqlDatabase::addDatabase("QSQLITE");
    m_database.setHostName("localhost");
}

QSqlDatabase& SQLiteDatabase::database() {
    return m_database;
}

bool SQLiteDatabase::open() {
    bool result = m_database.open();
    if(result && m_database.isOpen()) emit openedChanged();
    return result;
}

bool SQLiteDatabase::opened() {
    return m_database.isOpen();
}

bool SQLiteDatabase::valid() {
    return m_database.isValid();
}

QString SQLiteDatabase::databaseName() {
    return m_database.databaseName();
}

void SQLiteDatabase::setDatabaseName(const QString& name) {
    m_database.setDatabaseName(name);
    emit databaseNameChanged();
}

void SQLiteDatabase::close() {
    m_database.close();
    emit openedChanged();
}

bool SQLiteDatabase::transaction() {
    return m_database.transaction();
}

bool SQLiteDatabase::commit() {
    return m_database.commit();
}

bool SQLiteDatabase::create(QString filePath) {
    if(opened()) close();

    QFileInfo info(filePath);
    QDir(info.absolutePath()).mkpath(info.absolutePath());
    QFile file(filePath);

    if(file.exists()) file.remove();
    file.open(QIODevice::WriteOnly); //touch the file
    file.close();
    m_database.setDatabaseName(filePath);
    return open();
}

bool SQLiteDatabase::exec(QString query) {
    if(query.isEmpty())
        return m_lastQuery.exec();

    if(query.toLower().startsWith("begin transaction")) {
        m_lastQuery = QSqlQuery(m_database);
        return m_database.transaction();
    }
    if(query.toLower().startsWith("commit")) {
        m_lastQuery = QSqlQuery(m_database);
        return m_database.commit();
    }
    m_lastQuery = QSqlQuery(query, m_database);
    return m_lastQuery.exec();
}

bool SQLiteDatabase::prepare(QString query) {
    m_lastQuery = QSqlQuery(m_database);
    return m_lastQuery.prepare(query);
}

void SQLiteDatabase::bind(QString key, QVariant value) {
    m_lastQuery.bindValue(key, value);
}

QSqlQuery SQLiteDatabase::lastQuery() {
    return m_lastQuery;
}
