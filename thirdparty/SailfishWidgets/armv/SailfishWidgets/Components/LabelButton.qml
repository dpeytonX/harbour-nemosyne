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
   \qmltype LabelButton
   \since 5.0
   \brief A Clickable Label
   \inqmlmodule SailfishWidgets.Components

   Back to \l {Sailfish Widgets}

  Similar to a button in functionality except it uses a Label with no text decoration for the message.
  */
BackgroundItem {
    /*!
       \qmlproperty alias LabelButton::text
      An alias to the internal label's \c {text}
    */
  property alias text: lbl.text
    /*!
       \qmlproperty alias LabelButton::color
      An alias to the internal label's \c {color}
    */
  property alias color: lbl.color
  InformationalLabel {id: lbl; text: item.text}
}
