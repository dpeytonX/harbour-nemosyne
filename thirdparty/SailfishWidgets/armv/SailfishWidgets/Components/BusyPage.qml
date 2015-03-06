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

import QtQuick 2.1
import Sailfish.Silica 1.0

/*!
   \qmltype BusyPage
   \since 5.0
   \brief Shows a busy spinner with optional title
   \inqmlmodule SailfishWidgets.Components

   Back to \l {Sailfish Widgets}

  Displays a busy spinner in the center of the page with a Label above it for a description.

  The default action on accept is to pop everything above it in the stack
  and replace itself with the page that called it.
  
  You may also provide an \c acceptDestination to push another page on the stack just like a 
  regular Silica \c Dialog.
  */
Dialog {
    /*!
       \qmlsignal BusyPage::success
       Use this to signal the \l {BusyPage} to move to the \c acceptDestination
    */
    signal success()
    /*!
       \qmlsignal BusyPage::failure
       Use this to signal the \l {BusyPage} to return to the previous page
    */
    signal failure()

    /*!
       \qmlproperty alias BusyPage::running
      By default, this boolean property is true when this Dialog is \c Active or \c Activating
    */
    property alias running: busy.running
    /*!
       \qmlproperty alias BusyPage::size
      An alias to \c BusyIndicator.size. By default this is BusyIndicatorSize.Large
    */
    property alias size: busy.size
    /*!
       \qmlproperty alias BusyPage::title
      An alias to the label's text
    */
    property alias title: heading.text
    /*!
      \internal
    */
    property bool moveForward: false
    /*!
      \internal
    */
    property variant navigatePage: !!pageStack.find(function(p) { return p == this;}) ? pageStack.previousPage(this) : null

    allowedOrientations: Orientation.All
    acceptDestinationReplaceTarget: navigatePage
    acceptDestinationAction: PageStackAction.Replace
    canAccept: false
    showNavigationIndicator: false

    SectionHeader {
        anchors.bottom: busy.top
        anchors.bottomMargin: Theme.paddingLarge
        horizontalAlignment: Text.AlignHCenter
        id: heading
    }

    BusyIndicator {
        anchors.centerIn: parent
        id: busy
        running: status == PageStatus.Activating || status == PageStatus.Active
        size: BusyIndicatorSize.Large
    }

    onStatusChanged: {
        if(status == PageStatus.Active) {
            if(moveForward) accept()
            else reject()
            moveForward = false
            canAccept = false
        }
    }

    onSuccess: {
        canAccept = true
        moveForward = true
    }

    onFailure: {
        canAccept = false
        moveForward = false
    }
}
