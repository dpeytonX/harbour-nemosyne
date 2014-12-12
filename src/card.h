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

    QString question() const {return m_question;}
    QString answer() const {return m_answer;}

    void setQuestion(const QString& question) {m_question = question;}
    void setAnswer(const QString& answer) {m_answer = answer;}

private:
    QString m_question;
    QString m_answer;

};

#endif // CARD_H
