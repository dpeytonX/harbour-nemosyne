/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <QtQuick>
#include <QLocale>
#include <QDebug>

#include <sailfishapp.h>

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    qDebug() << sysLocale << uiLanguage;

    // As a neat trick, you can have SailfishApp generate the QApp here, and still
    // bootstrap your QtQuick stuff using SailfishApp::main
    QGuiApplication *app = SailfishApp::application(argc, argv);

    //Locale setup
    // Find the app specific locale (system setting)
    // If it is empty or the same the system locale, leave
    // Else
    //   match the locale to a qm file
    //   If match found
    //     Load the translation
    QLocale locale = QLocale::system();
    QString sysLocale = locale.name();
    QStringList uiLanguage = locale.uiLanguages();

    /* Sample code from ownkeepass
     *  QTranslator translator;
if (settingsPublic::Languages::SYSTEM_DEFAULT != okpSettings->language()) {
switch (okpSettings->language()) {
// LANG_CA
case settingsPublic::Languages::CA:
translator.load("harbour-ownkeepass-ca.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
// LANG_ZH_CN
case settingsPublic::Languages::ZH_CN:
translator.load("harbour-ownkeepass-zh_CN.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
// LANG_CS_CZ
case settingsPublic::Languages::CS_CZ:
translator.load("harbour-ownkeepass-cs_CZ.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
// LANG_DA
case settingsPublic::Languages::DA:
translator.load("harbour-ownkeepass-da.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
// LANG_NL_NL
case settingsPublic::Languages::NL_NL:
translator.load("harbour-ownkeepass-nl_NL.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
// LANG_EN_GB - using default ts file
// LANG_FI_FI
case settingsPublic::Languages::FI_FI:
translator.load("harbour-ownkeepass-fi_FI.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
// LANG_FR_FR
case settingsPublic::Languages::FR_FR:
translator.load("harbour-ownkeepass-fr_FR.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
// LANG_DE_DE
case settingsPublic::Languages::DE_DE:
translator.load("harbour-ownkeepass-de_DE.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
// LANG_IT
case settingsPublic::Languages::IT:
translator.load("harbour-ownkeepass-it.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
// LANG_PL_PL
case settingsPublic::Languages::PL_PL:
translator.load("harbour-ownkeepass-pl_PL.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
// LANG_RU
case settingsPublic::Languages::RU:
translator.load("harbour-ownkeepass-ru.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
// LANG_ES
case settingsPublic::Languages::ES:
translator.load("harbour-ownkeepass-es.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
// LANG_SV_SE
case settingsPublic::Languages::SV_SE:
translator.load("harbour-ownkeepass-sv_SE.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
// LANG_UK_UA
case settingsPublic::Languages::UK_UA:
translator.load("harbour-ownkeepass-uk_UA.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
default:
translator.load("harbour-ownkeepass.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
break;
}
// install translator for specific language
// otherwise the system language will be se
*/

    return SailfishApp::main(argc, argv);
}

