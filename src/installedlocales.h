#ifndef LOCALEHELPER_H
#define LOCALEHELPER_H

#include <QObject>

#include "locale.h"

/*!
 * Gets the locales available to the application for translation.
 * [qsTr("Application Default")].concat(ls.getTranslationLocales(UIConstants.appName))
 *
 * This application will retrieve the harbour-*.qm files and strip the locale suffix then convert them
 * into QML objects that client applications can then access and show to the user.
 *
 * This class can also inject a default application locale (user specified) so that end-user apps can
 * use a single model to represent all possible language selections to the user.
 */
class InstalledLocales : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<Locale> locales READ locales)
public:
    InstalledLocales(QObject* parent=0);

    /* TODO:This needs to return a QQmlListProperty
     * Q_INVOKABLE QStringList getTranslationLocales(const QString& app) {
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

};

#endif // LOCALEHELPER_H
