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
#ifndef SAILFISHMAIN_H
#define SAILFISHMAIN_H

#include <sailfishapp.h>
#include <sailfishmain_global.h>

#include <QString>
#include <QCoreApplication>
#include <QDebug>

namespace SailfishMain
{
SAILFISHMAIN_EXPORT void temp() { qDebug() << "out"; }


SAILFISHMAIN_EXPORT int main(int argc, char *argv[], const QString& appName=QString(""), const QString& settingsFile=QString(""), const QString& localeSetting=QString("locale"));

SAILFISHMAIN_EXPORT bool installLanguage(const QString& appName, const QString& locale, QCoreApplication* app);

}

#endif // SAILFISHMAIN_H
