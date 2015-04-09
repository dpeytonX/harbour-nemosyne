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
import Sailfish.Silica 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.3

Row{
    property int unmemorized
    property int scheduled
    property int active
    spacing: Theme.paddingMedium
    id: root

    Column {

        Row {
            spacing: Theme.paddingMedium

            Subtext {
                text: qsTr("scheduled")
                width: Math.min(500, root.width * .6)
            }

            Subtext {
                color: "white"
                text: scheduled
            }
        }

        Row {
            spacing: Theme.paddingMedium

            Subtext {
                text: qsTr("unmemorized")
                width: Math.min(500, root.width * .6)
            }

            Subtext {
                color: "white"
                text: unmemorized
            }
        }

        Row {
            spacing: Theme.paddingMedium

            Subtext {
                text: qsTr("active")
                width: Math.min(500, root.width * .6)
            }

            Subtext {
                color: "white"
                text: active
            }
        }
    }

}
