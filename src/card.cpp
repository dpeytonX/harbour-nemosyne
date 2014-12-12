#include "card.h"
#include <QDebug>

Card::Card(QObject *parent) :
    QObject(parent),
    m_question(""), m_answer("")
{
}

Card::~Card() {
    qDebug() << "disposed card";
}
