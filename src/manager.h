#ifndef MANAGER_H
#define MANAGER_H

#include <QObject>
#include <QString>
#include <QtSql/QSqlDatabase>

#include "sqlitedatabase.h"
#include "card.h"

class Manager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int scheduled READ scheduled NOTIFY scheduledChanged)
    Q_PROPERTY(int unmemorized READ unmemorized NOTIFY unmemorizedChanged)
    Q_PROPERTY(int active READ active NOTIFY activeChanged)
public:
    Manager(QObject *parent=0);

    Q_INVOKABLE bool isValidDb(QString filePath);
    Q_INVOKABLE Card* next(int rating);
    Q_INVOKABLE bool create(QString filePath);
    Q_INVOKABLE bool initialize();

    int active() const {return m_active;}
    int scheduled() const {return m_scheduled;}
    int unmemorized() const {return m_unmemorized;}

    void setActive(int value) {m_active = value; emit activeChanged();}
    void setScheduled(int value) {m_scheduled = value; emit scheduledChanged();}
    void setUnmemorized(int value) {m_unmemorized = value; emit unmemorizedChanged();}

signals:
    void activeChanged();
    void scheduledChanged();
    void unmemorizedChanged();
private:
    enum Timing : int;
    void initTrackingValues();
    void grade(int rating);
    void saveCard();
    qint64 calculateInitialInterval(int rating, Timing timing, qint64 actualInterval, qint64 scheduledInterval);

    int m_active;
    int m_scheduled;
    int m_unmemorized;

    SQLiteDatabase m_database;
    QSqlDatabase m_nemo;
    Card* m_currentCard;
};

#endif // MANAGER_H
