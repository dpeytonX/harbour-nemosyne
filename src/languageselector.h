#ifndef LANGUAGESELECTOR_H
#define LANGUAGESELECTOR_H

#include <QObject>
#include <QCoreApplication>
#include <QLocale>
#include <QTranslator>
#include <sailfishapp.h>

class LanguageSelector : public QObject
{
    Q_OBJECT

public:
    explicit LanguageSelector(QObject *parent=0);

    static inline bool installLanguage(const QString& appName, const QString& locale, QCoreApplication* app) {
        if(m_translator.load(appName + "-" + locale + ".qm", SailfishApp::pathTo(QString("translations")).toLocalFile())) {
          app->installTranslator(&m_translator);
          return true;
        }
        return false;
    }

    Q_INVOKABLE inline QString getLanguage(const QString& locale) const {
        return QLocale(locale).nativeLanguageName();
    }

    Q_INVOKABLE inline QString getCountry(const QString& locale) const {
        return QLocale(locale).nativeCountryName();
    }

private:
    static QTranslator m_translator;
};

#endif // LANGUAGESELECTOR_H
