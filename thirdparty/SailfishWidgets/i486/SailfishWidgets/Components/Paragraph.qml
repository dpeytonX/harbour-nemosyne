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

import Sailfish.Silica 1.0

/*!
   \qmltype Paragraph
   \since 5.0
   \brief Can be used to add detailed information in the UI.
   \inqmlmodule SailfishWidgets.Components

   Back to \l {Sailfish Widgets}

   TextArea with a small font size and secondary highlighting. Used for explanations which are intended to word wrap. Due to the nature of the TextArea, it must be set a width in order for it to be displayed within a Column. This is set to be the parent's width. If you need more control over the dimensions, you may wish to use Subtext, instead.
*/
TextArea {
    color: Theme.secondaryHighlightColor
    font.family: Theme.fontFamilyHeading
    font.pixelSize: Theme.fontSizeSmall
    readOnly: true
    width: parent.width
}
