#ifndef SQLITEDATABASE_H
#define SQLITEDATABASE_H

#include <QObject>
#include <QtSql/QSqlDatabase>

class SQLiteDatabase : public QObject
{
public:
    SQLiteDatabase(QObject parent=0);

private:
    QSqlDatabase m_database;
};

#endif // SQLITEDATABASE_H
