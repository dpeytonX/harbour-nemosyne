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
   \qmltype RadioGroup
   \since 5.0
   \brief Togglable set of TextSwitch components
   \inqmlmodule SailfishWidgets.Components

   Back to \l {Sailfish Widgets}

   This will display a set (of up to 4) TextSwitches in a single row. Designed to allow only one selection to be used at a time.
*/
Row {
    /*!
       \qmlproperty alias RadioGroup::radio1
       Alias to the TextSwitch at index 1.
    */
    property alias radio1: p1
    /*!
       \qmlproperty alias RadioGroup::radio2
       Alias to the TextSwitch at index 2.
    */
    property alias radio2: p2
    /*!
       \qmlproperty alias RadioGroup::radio3
       Alias to the TextSwitch at index 3.
    */
    property alias radio3: p3
    /*!
       \qmlproperty alias RadioGroup::radio4
       Alias to the TextSwitch at index 4.
    */
    property alias radio4: p4
    /*!
       \qmlproperty alias RadioGroup::radioMargin
       Controls the rightMargin property of all TextSwitches in this RadioGroup.
    */
    property real radioMargin: Theme.paddingLarge
    /*!
       \qmlproperty alias RadioGroup::radiosVisible
       Read-only property of the total number of TextSwitches that are visible.
    */
    readonly property int radiosVisible: p1.visible + p2.visible + p3.visible + p4.visible
    /*!
       \qmlproperty alias RadioGroup::defaultIndex
       Set to the TextSwitch which should hold the default check.
    */
    property TextSwitch defaultIndex

    /*!
       \qmlsignal RadioGroup::reset
       Calls reset
    */
    signal reset
    /*!
       \qmlsignal RadioGroup::radioClicked
       Emitted when a TextSwitch in this group has been clicked. The only parameter is a reference to the TextSwitch component.
       \c onRadioClicked
    */
    signal radioClicked(TextSwitch radio)
    /*!
       \qmlsignal RadioGroup::radioStateChanged
       Emitted when a TextSwitch in this group has changed checked state. The only parameter is a reference to the TextSwitch component.
       \c onRadioStateChanged
    */
    signal radioStateChanged(TextSwitch radio)

    TextSwitch {
        automaticCheck: false
        checked: defaultIndex == this
        id: p1
        rightMargin: radioMargin
        visible: !!text
        width: parent.width / radiosVisible

        property variant value

        onCheckedChanged: radioStateChanged(this)
        onClicked: radioClicked(this)
    }

    TextSwitch {
        automaticCheck: false
        checked: defaultIndex == this
        id: p2
        rightMargin: radioMargin
        visible: !!text
        width: parent.width / radiosVisible

        property variant value

        onCheckedChanged: radioStateChanged(this)
        onClicked: radioClicked(this)
    }

    TextSwitch {
        automaticCheck: false
        checked: defaultIndex == this
        id: p3
        rightMargin: radioMargin
        visible: !!text
        width: parent.width / radiosVisible

        property variant value

        onCheckedChanged: radioStateChanged(this)
        onClicked: radioClicked(this)
    }

    TextSwitch {
        automaticCheck: false
        checked: defaultIndex == this
        id: p4
        rightMargin: radioMargin
        visible: !!text
        width: parent.width / radiosVisible

        property variant value

        onCheckedChanged: radioStateChanged(this)
        onClicked: radioClicked(this)
    }

    onRadioClicked: {
        switch(radio) {
        case p1:
            p1.checked = true
            p2.checked = false
            p3.checked = false
            p4.checked = false
            break
        case p2:
            p2.checked = true
            p1.checked = false
            p3.checked = false
            p4.checked = false
            break
        case p3:
            p3.checked = true
            p1.checked = false
            p2.checked = false
            p4.checked = false
            break
        default:
            p4.checked = true
            p1.checked = false
            p2.checked = false
            p3.checked = false
            break
        }
    }
}
