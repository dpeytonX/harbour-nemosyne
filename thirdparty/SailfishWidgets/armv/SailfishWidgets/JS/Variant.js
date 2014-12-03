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

/*!
   \qmltype Variant
   \since 5.0
   \brief Provides constants for accessing manipulating variant types

   Back to \l {Sailfish Widgets}

*/
.pragma library

function remove(variant, obj) {
    var i = variant.indexOf(obj)
    var temp = variant
    temp.splice(i, 1)
    return temp
}

function add(variant, obj) {
    return variant.concat(obj)
}
