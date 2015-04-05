#ifndef LANGUAGESELECTOR_H
#define LANGUAGESELECTOR_H

#include <QObject>
#include <QDebug>
#include <QDir>
#include <QCoreApplication>
#include <QLocale>
#include <QTranslator>
#include <QStringList>
#include <sailfishapp.h>

class LanguageSelector : public QObject
{
    Q_OBJECT

public:
    explicit LanguageSelector(QObject *parent=0);

    static inline bool installLanguage(const QString& appName, const QString& locale, QCoreApplication* app) {
        if(m_translator.load(appName + (locale.isEmpty() ? ".qm" : ("-" + locale + ".qm")), SailfishApp::pathTo(QString("translations")).toLocalFile())) {
            app->installTranslator(&m_translator);
            return true;
        }
        return false;
    }

    Q_INVOKABLE inline QString getPrettyName(const QString& locale) const {
        QString lang(getLanguage(locale));
        QString ctry(getCountry(locale));
        if(ctry.isEmpty()) {
            return lang;
        }
        return lang + " (" + ctry + ")";
    }

    Q_INVOKABLE inline QString getLanguage(const QString& locale) const {
        return QLocale(locale).nativeLanguageName();
    }

    Q_INVOKABLE inline QString getCountry(const QString& locale) const {
        return QLocale(locale).nativeCountryName();
    }

    Q_INVOKABLE QStringList getTranslationLocales(const QString& app) {
        QStringList locales;
        QDir dir(SailfishApp::pathTo(QString("translations")).toLocalFile());
        QStringList qmlFiles = dir.entryList();
        for(const QString& qmlFile : qmlFiles) {
            int posQm = qmlFile.lastIndexOf(".qm");
            if(app.size() >= qmlFile.size() || app.size() >= posQm || posQm == -1) continue;
            locales.append(qmlFile.mid(app.size() + 1, posQm - app.size() - 1));
        }

        return locales;
    }

private:
    static QTranslator m_translator;
};

#endif // LANGUAGESELECTOR_H
