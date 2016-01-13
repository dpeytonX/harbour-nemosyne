/***************************************************************************
** This file is part of Nemosyne
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
import harbour.nemosyne.SailfishWidgets.Components 1.4
import harbour.nemosyne.SailfishWidgets.Settings 1.4
import harbour.nemosyne.Nemosyne 1.0
import harbour.nemosyne.QmlLogger 2.0

Note {
    property bool ratingVisible: settings.slideRatings && !viewOnly
    property string answer

    signal rated(int rating)

    objectName: "answer"
    id: root

    ApplicationSettings {
        id: settings
        applicationName: "harbour-nemosyne"
        fileName: "settings"

        property int defaultFontSizeId: 0
        property bool slideRatings: false
    }

    FontHandler {id: fh}

    PageHeader {
        id: header;
        title: ratingVisible ? qsTr("Rate") : ""
    }

    SilicaFlickable {
        id: sf
        width: parent.width - (ratingVisible ? ratingCol.width : 0)
        height: parent.height - header.height
        y: header.height
        // Hackish, but the only way to prevent ratingCol from taking over the screen
        contentHeight: Math.max(height - Theme.paddingLarge * 2, contentCol.childrenRect.height)

        Column {
            id: contentCol
            width: parent.width - Theme.paddingSmall - Theme.paddingLarge
            x: Theme.paddingLarge

            Paragraph {
                color: Theme.primaryColor
                width: parent.width;
                font.pixelSize: fh.fontIndices[settings.defaultFontSizeId]
                text: answer
            }

            PushUpMenu {
                id: pushMenu
                visible: !viewOnly && !ratingVisible

                StandardMenuItem {
                    text: qsTr("rating")
                }

                Repeater {
                    model: 6
                    delegate: StandardMenuItem {
                        property int value: index
                        text: index
                        onClicked: rated(value)
                    }
                }
            }
        }

        VerticalScrollDecorator {}
    }

    Column {
        id: ratingCol
        spacing: orientation == Orientation.Portrait || orientation == Orientation.PortraitInverted ? Theme.paddingLarge : 0
        visible: ratingVisible
        x: 0
        y: sf.y
        z: sf.z - 10 //ratingCol should always subordinate to prevent stealing

        Repeater {
            model: UIConstants.ratings
            delegate: PageIndicator {
                property int value: modelData
                property int defaultHeight: 0
                property int landscape: (root.height - header.height - Theme.paddingLarge)/UIConstants.ratings.length
                page: root
                text: value
                onAccepted: rated(value)
                onHeightChanged: Console.debug("Answer: height " + height)

                Component.onCompleted: {
                    ratingCol.width = Math.max(ratingCol.width, contentWidth)
                    defaultHeight = height
                    _resize()
                    pageStack.busyChanged.connect(_reset)
                    orientationChanged.connect(_resize)
                }

                function _reset() {
                    if(!pageStack || pageStack.busy || pageStack.currentPage != root) return

                    reset() //reset the indicator
                }

                function _resize() {
                    height = orientation == Orientation.Portrait || orientation == Orientation.PortraitInverted ?
                                defaultHeight : landscape
                }
            }
        }
    }
}
