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

import QtQuick 2.1
import Sailfish.Silica 1.0

/*!
   \qmltype PageIndicator
   \since 5.1
   \brief A swipable page indicator
   \inqmlmodule SailfishWidgets.Components

   Back to \l {Sailfish Widgets}

   This component will show a glass item on the right hand side of a parent (page) along with a label indicating an option for the user to select. Once the user has selected an item either an \c accepted() or \c rejected() will be emitted.

  Placing multiple instances on a page can provide the user multiple options with which to accept a page without the need for extra buttons, pulley menu items, or toggle switches.
*/
Flickable {
    /*!
       \qmlproperty alias PageIndicator::text
       Alias for the text that appears for the indicator's label.
    */
    property alias text: label.text
    /*!
       \qmlproperty false PageIndicator::enabled
       Sets whether this page indicator takes user input.
    */
    property bool enabled: true
    /*!
      \internal
    */
    property bool _hasAccepted: false
    /*!
      \internal
    */
    property real _startWidth: width - contentWidth + 50
    /*!
       \qmlproperty alias PageIndicator::acceptPoint
       Sets the width of the swiping area before emmitted the \c accepted() signal. By default is is two-thirds of the available page width.
    */
    property real acceptPoint: _startWidth / 3 * 2
    /*!
       \qmlproperty alias PageIndicator::page
       Sets the page in which the indicator should manipulate. It defaults to parent.
    */
    property variant page: parent
    /*!
       \qmlsignal PageIndicator::accepted
       Emitted when the user has swiped the indicator past the \c acceptPoint.
    */
    signal accepted()
    /*!
       \qmlsignal PageIndicator::rejected
       Emitted when the user has released the indicator back to neutral position.
    */
    signal rejected()

    id:flicky
    width: page.width
    height: row.height
    interactive: enabled
    opacity: _hasAccepted ? 0 : 1

    contentWidth: row.width
    contentHeight: height
    contentItem.transform: Translate { x: flicky._startWidth }
    flickableDirection: Flickable.HorizontalFlick
    boundsBehavior: Flickable.DragAndOvershootBounds
    maximumFlickVelocity: 1000

    onContentXChanged: {
        if(_hasAccepted) return

        page.opacity = 1 - contentX / acceptPoint

        if(contentX >= acceptPoint) {
            _hasAccepted = true
            accepted()
        } else if(contentX == 0){
            rejected()
        }
    }

    Row {
        id: row
        width: childrenRect.width
        spacing: 0

        InformationalLabel {
            anchors.verticalCenter: parent.verticalCenter
            id: label
            opacity: flicky.enabled ? 1.0 : 0.4
        }

        GlassItem {
            anchors.verticalCenter: parent.verticalCenter
            id: glass
            dimmed: !flicky.enabled
        }
    }

    /*!
       \qmlsignal PageIndicator::reset
       Resets the accepted status and returns the page back to full opacity.
    */
    function reset() { _hasAccepted = false; page.opacity = 1 }
}
