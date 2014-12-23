#include "sqlitedatabase.h"

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QString>
#include <QStringList>
#include <QSqlError>

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

bool SQLiteDatabase::execBatch(QStringList batch, bool ignoreErrors) {
    foreach(QString c, batch) {
        if(c.trimmed().isEmpty()) continue;

        if(!exec(c) && !ignoreErrors) {
            qDebug() << "exec batch: error occurred " << c << lastError();
            return false;
        }
    }
    return true;
}

bool SQLiteDatabase::exec(QString query) {
    query = query.trimmed();

    if(query.isEmpty())
        return m_lastQuery.exec();

    if(query.at(query.length() - 1) != ';') query.append(";");

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

QString SQLiteDatabase::lastError() {
    return m_lastQuery.lastError().text();
}
