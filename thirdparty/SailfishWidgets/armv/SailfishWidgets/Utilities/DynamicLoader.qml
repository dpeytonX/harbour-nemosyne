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

/*!
   \qmltype DynamicLoader
   \since 5.0
   \brief Creates an object instance of a Component
   \inqmlmodule SailfishWidgets.Utilities

   Back to \l {Sailfish Widgets}

   Provides signals for creating dynamic objects from Component types.
*/
Item {
    /*!
       \qmlsignal DynamicLoader::create
       Call this signal to begin object creation. Pass in the QML Component, its parent, and properties.
       \c onCreate
    */
    signal create(Component component, variant parent, variant properties)
    /*!
       \qmlsignal DynamicLoader::error
       Emitted when an error has occurred with object creation.
       \c onError
    */
    signal error(string errorString)
    /*!
       \qmlsignal DynamicLoader::objectCompleted
       Emitted when the object creation has completed.
       \c onObjectCompleted
    */
    signal objectCompleted(variant object)

    onCreate: {
        if(!!component && component.status === Component.Ready) {
            var o = component.createObject(parent, properties)
            objectCompleted(o)
        } else {
            error(component.errorString())
        }
    }
}
