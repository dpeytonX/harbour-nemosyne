#include "query.h"

#include <QSqlRecord>
#include <QSqlError>

Query::Query(const QSqlQuery &query, QObject *parent) :
    QObject(parent), QSqlQuery(query)
{
}

bool Query::first() {
    return QSqlQuery::first();
}

bool Query::next() {
    return QSqlQuery::next();
}

bool Query::last() {
    return QSqlQuery::last();
}

bool Query::seek(int index, bool relative) {
    return QSqlQuery::seek(index, relative);
}

int Query::indexOf(const QString& field) {
    return record().indexOf(field);
}

QString Query::lastError() const {
    return QSqlQuery::lastError().text();
}

QVariant Query::value(const QString& name) {
    return QSqlQuery::value(name);
}
