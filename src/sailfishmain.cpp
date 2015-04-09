/***************************************************************************
** This file is part of SailfishWidgets
**
** Copyright (c) 2015 Dametrious Peyton
**
** $QT_BEGIN_LICENSE:GPLV3$
** SailfishWidgets is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** SailfishWidgets is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with SailfishWidgets.  If not, see <http://www.gnu.org/licenses/>.
** $QT_END_LICENSE$
**
**************************************************************************/

#include "sailfishmain.h"

#include <QCoreApplication>
#include <QString>
#include <QTranslator>

#include <applicationsettings.h>
#include <languageselector.h>

#include <sailfishapp.h>

/*!
   \namespace SailfishMain
   \since 5.2
   \brief The SailfishMain namespace

   \inmodule Core

   This namespace supports the quick construction of SailfishApps.

   Back to \l {Sailfish Widgets}
 */

/*!
 \fn int SailfishMain::main(int argc, char *argv[], const QString& appName, const QString& settingsFile, const QString& localeSetting)

 Constructs a Sailfish application using \a appName and \a settingsFile to load the application settings with a given \a localeSetting property.
 If no locale was discovered, the default translation bundle is loaded using \a appName .qm file.

 Finally, a Sailfish application is constructed using the \a argc and \a argv parameters.
 */
int SailfishMain::main(int argc, char *argv[], const QString& appName, const QString& settingsFile, const QString& localeSetting) {
    if(!appName.isEmpty() && !settingsFile.isEmpty()) {
        ApplicationSettings settings(appName, settingsFile);
        installLanguage(appName, settings.isValid(localeSetting) ? settings.value(localeSetting) : "",
                                          SailfishApp::application(argc, argv));
    }

    return SailfishApp::main(argc, argv);
}

/*!
 \fn bool SailfishMain::installLanguage(const QString& appName, const QString& locale, QCoreApplication* app)

 Installs the \a locale for the given \a appName of the application \a app.

 Returns true if successful.
 */
bool SailfishMain::installLanguage(const QString& appName, const QString& locale, QCoreApplication* app) {
    if(QTranslator().load(appName + (locale.isEmpty() ? ".qm" : ("-" + locale + ".qm")),
                          SailfishApp::pathTo(QString("translations")).toLocalFile())) {
        return app->installTranslator(&m_translator);
    }
    return false;
}
