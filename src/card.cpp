#include "card.h"
#include <QDebug>

Card::Card(QObject *parent) :
    QObject(parent),
    m_question(""), m_answer(""), m_nextRep(0l), m_lastRep(0l)
{
}

Card::~Card() {
    qDebug() << "disposed card";
}
