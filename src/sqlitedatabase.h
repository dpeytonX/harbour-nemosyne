#ifndef SQLITEDATABASE_H
#define SQLITEDATABASE_H

#include <QObject>
#include <QString>
#include <QVariant>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>

class SQLiteDatabase : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool opened READ opened NOTIFY openedChanged)
    Q_PROPERTY(bool valid READ valid)
    Q_PROPERTY(QString databaseName READ databaseName WRITE setDatabaseName NOTIFY databaseNameChanged)
    Q_PROPERTY(QString lastError READ lastError)

public:
    SQLiteDatabase(QObject *parent=0);
    QSqlDatabase &database();

    Q_INVOKABLE bool open();
    Q_INVOKABLE void close();
    Q_INVOKABLE bool create(QString filePath);
    Q_INVOKABLE bool transaction();
    Q_INVOKABLE bool commit();
    Q_INVOKABLE bool exec(QString query=QString());
    Q_INVOKABLE bool execBatch(QStringList batch, bool ignoreErrors=false);
    Q_INVOKABLE bool prepare(QString query);
    Q_INVOKABLE void bind(QString key, QVariant value);

    bool opened();
    bool valid();
    QString databaseName();
    void setDatabaseName(const QString& name);
    QSqlQuery lastQuery();
    QString lastError();

signals:
    void openedChanged();
    void databaseNameChanged();

private:
    QSqlDatabase m_database;
    QSqlQuery m_lastQuery;
};

#endif // SQLITEDATABASE_H
