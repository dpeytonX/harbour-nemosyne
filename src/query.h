#ifndef QUERY_H
#define QUERY_H

#include <QObject>
#include <QVariant>
#include <QtSql/QSqlQuery>

class Query : public QObject, public QSqlQuery
{
    Q_OBJECT
    Q_PROPERTY(bool active READ isActive)
    Q_PROPERTY(bool valid READ isValid)
    Q_PROPERTY(int size READ size)
    Q_PROPERTY(QString lastError READ lastError)

public:
    explicit Query(const QSqlQuery& query=QSqlQuery(), QObject *parent = 0);

    Q_INVOKABLE bool first();
    Q_INVOKABLE bool last();
    Q_INVOKABLE bool next();
    Q_INVOKABLE bool seek(int index, bool relative=false);
    Q_INVOKABLE int indexOf(const QString& field);
    Q_INVOKABLE QVariant value(const QString& name);

    QString lastError() const;

signals:

public slots:

};

#endif // QUERY_H
