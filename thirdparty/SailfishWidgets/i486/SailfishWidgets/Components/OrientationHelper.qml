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
   \qmltype OrientationHelper
   \since 5.2
   \brief Makes any new pages inherit the orientation setting of the parent
   \inqmlmodule SailfishWidgets.Components

   Back to \l {Sailfish Widgets}

   By inserting an \c OrientationHelper into your \c Page or \c Dialog, you can make any other pages spawned from it to
   inherit the \c allowedOrientation property.

   This is most useful for Sailfish Silica components like \c ComboBox or \c TimePickerDialog where you do not have access to the internal \c Page
   that the user interacts with.

  \code
   OrientationHelper {
     excludes: ["_my_page"]
   }

   Dialog {
     id: t
   } // This will inherit the orientation settings of parent

   Component {
     id: myPage
     Page { 
       property int _my_page
     }
   }
  \endcode

  */
Item {
    /*!
       \qmlproperty var OrientationHelper::excludes
      This holds the string properties which if exists serve to exclude child \c Pages from inheriting the parent's orientation settings.
    */
    property var excludes
    id: helper

    Connections {
        target: pageStack
        onCurrentPageChanged: {
            if(helper.parent.hasOwnProperty("__silica_page") && !!pageStack.currentPage && pageStack.previousPage() == helper.parent) {
                if(!!excludes && excludes.length > 0) {
                    for (var i = 0; i < excludes.length; i++) {
                        if(pageStack.currentPage.hasOwnProperty(excludes[i])) return;
                    }
                }

                pageStack.currentPage.allowedOrientations = helper.parent.allowedOrientations
                pageStack.currentPage.anchors.fill = null
                pageStack.currentPage.width = helper.parent.width
                pageStack.currentPage.height = helper.parent.height

            }
        }
    }
}
