#ifndef MANAGER_H
#define MANAGER_H

#include <QObject>
#include <QString>

class Manager : public QObject
{
    Q_OBJECT
public:
    Manager(QObject *parent=0);

    Q_INVOKABLE bool isValidDb(QString filePath);

};

#endif // MANAGER_H
