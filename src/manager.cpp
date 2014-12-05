#include "manager.h"

Manager::Manager(QObject *parent) : QObject(parent)
{
}

bool Manager::isValidDb(QString filePath) {
    //Step 1: Check if this is an sql lite db
    //Step 2: Check for a mnemosyne table for verification
    return true;
}
