/***************************************************************************
** This file is part of Nemosyne
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
import QtQuick 2.1

/*!
   \qmltype Card
   \since 5.1
   \brief Respresents qualities of a flash card
   \inqmlmodule org.harbour.nemosyne

   Represents fields of a flash card. Used primarily as a data bean.
  */
Item {
    property int acquisition
    property int acquisitionRepsSinceLapse
    property int grade
    property int lapses
    property int lastRep
    property int nextRep
    property int retentionRep
    property int retentionRepsSinceLapse
    property int seq
    property real easiness
    property string question
    property string answer
    property int factId
    property string hash
    property int cardTypeId
    property int factViewId
    property string tags
}
