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

class QString;
class QCoreApplication;

namespace SailfishMain
{

int main(int argc, char *argv[], const QString& appName="", const QString& settingsFile="", const QString& localeSetting="locale");

bool installLanguage(const QString& appName, const QString& locale, QCoreApplication* app);

}

#endif // SAILFISHMAIN_H
