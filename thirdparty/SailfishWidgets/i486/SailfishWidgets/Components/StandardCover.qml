/***************************************************************************
** This file is part of SailfishWidgets
**
** Copyright (c) 2014 Dametrious Peyton
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

import QtQuick 2.0
import Sailfish.Silica 1.0
/*!
   \qmltype StandardCover
   \since 5.0
   \brief Default cover with an image and a short title
   \inqmlmodule SailfishWidgets.Components

   Back to \l {Sailfish Widgets}

   This will display a default cover with an image and a short title (usually for showing your application name)
*/
CoverBackground {
    /*!
       \qmlproperty alias StandardCover::coverTitle
       Short title to display for the cover.
    */
    property string coverTitle
    /*!
       \qmlproperty alias StandardCover::displayDefault
       Show the icon and title (defaults to true). Use false to hide the image and label and show your own application status.
    */
    property bool displayDefault: true
    /*!
       \qmlproperty alias StandardCover::imageSource
       An image source string for the cover icon.
    */
    property string imageSource
    /*!
       \qmlproperty alias StandardCover::im
       Alias to the cover image.
    */
    property alias image: im
    /*!
       \qmlproperty alias StandardCover::lb
       Alias to the cover label.
    */
    property alias label: lb

    Item {
        id: im
        anchors.fill: parent
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingLarge
        visible: displayDefault
        z: -100

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.6
            source: imageSource
        }
    }

    InformationalLabel {
        id: lb
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        text: coverTitle
        visible: displayDefault
    }
}
