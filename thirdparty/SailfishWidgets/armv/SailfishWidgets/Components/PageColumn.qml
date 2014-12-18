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
   \qmltype PageColumn
   \since 5.0
   \brief Column to be used in Page elements
   \inqmlmodule SailfishWidgets.Components

   Back to \l {Sailfish Widgets}

   Use within Page elements to create a vertical layout. This colum uses the standard Sailfish Silica padding and provides a PageHeader for convience.
*/
Column {
    width: parent.width - Theme.paddingLarge * 2
    x: Theme.paddingLarge

    /*!
       \qmlproperty alias PageColumn::title
       Sets the title for the PageHeader. It defaults to a blank space in order to preserve the column's layout.
   */
    property alias title: header.title

    PageHeader {
        id: header
        title: ""
    }
}
