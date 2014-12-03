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
   \qmltype MathHelper
   \since 5.0
   \brief Provides additional math functions.

   Back to \l {Sailfish Widgets}

*/
.pragma library

function isIntersectRect(source, target) {
    var sx = source.x
    var sy = source.y
    var sh = source.height + sy
    var sw = source.width + sx
    var tx = target.x
    var ty = target.y
    var th = target.height + ty
    var tw = target.width + tx

    return isIntersectPoints(sx, sy, sw, sh, tx, ty, tw, th)
}

function isIntersectPoints(sx, sy, sw, sh, tx, ty, tw, th) {
    return (tx <= sx && sx <= tw || tx <= sw && sw <= tw) &&
           (ty <= sy && sy <= th || ty <= sh && sh <= th)
}

function randomInt(min, max) {
    return Math.floor(Math.random() * (max - min)) + min
}


