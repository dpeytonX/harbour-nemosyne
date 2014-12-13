#include "card.h"
#include <QDebug>

Card::Card(QObject *parent) :
    QObject(parent), m_seq(0),
    m_question(""), m_answer(""), m_nextRep(0l), m_lastRep(0l), m_grade(0),
    m_easiness(0.0), m_acquisition(0), m_acquisitionRepsSinceLast(0),
    m_retentionRep(0), m_lapses(0), m_retentionRepsSinceLast(0)
{
}

Card::~Card() {
    qDebug() << "disposed card";
}
