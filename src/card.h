#ifndef CARD_H
#define CARD_H

#include <QObject>
#include <QString>

class Card : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString question READ question CONSTANT)
    Q_PROPERTY(QString answer READ answer CONSTANT)

public:
    explicit Card(QObject *parent = 0);
    ~Card();

    int seq() const {return m_seq;}
    QString question() const {return m_question;}
    QString answer() const {return m_answer;}
    qint64 nextRep() const {return m_nextRep;}
    qint64 lastRep() const {return m_lastRep;}
    int grade() const {return m_grade;}
    double easiness() {return m_easiness;}
    int acquisition() {return m_acquisition;}
    int acquisitionRepsSinceLast() {return m_acquisitionRepsSinceLast;}
    int retentionRep() {return m_retentionRep;}
    int lapses() {return m_lapses;}
    int retentionRepsSinceLast() {return m_retentionRepsSinceLast;}

    void setSeq(qint64 seq) {m_seq = seq;}
    void setQuestion(const QString& question) {m_question = question;}
    void setAnswer(const QString& answer) {m_answer = answer;}
    void setNextRep(qint64 nextRep) {m_nextRep = nextRep;}
    void setLastRep(qint64 lastRep) {m_lastRep = lastRep;}
    void setGrade(int grade) {m_grade = grade;}
    void setEasiness(double easiness) {m_easiness = easiness;}
    void setAcquisition(int acquisition) {m_acquisition = acquisition;}
    void setAcquisitionRepsSinceLast(int acquisitionRepsSinceLast) {m_acquisitionRepsSinceLast = acquisitionRepsSinceLast;}
    void setRetentionRep(int retentionRep) {m_retentionRep = retentionRep;}
    void setLapses(int lapses) {m_lapses = lapses;}
    void setRetentionRepsSinceLast(int retentionRepsSinceLast) {m_retentionRepsSinceLast = retentionRepsSinceLast;}

private:
    qint64 m_seq;
    QString m_question;
    QString m_answer;
    qint64 m_nextRep;
    qint64 m_lastRep;
    int m_grade;
    double m_easiness;
    int m_acquisition;
    int m_acquisitionRepsSinceLast;
    int m_retentionRep;
    int m_lapses;
    int m_retentionRepsSinceLast;
};

#endif // CARD_H
