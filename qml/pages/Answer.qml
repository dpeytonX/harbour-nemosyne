import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.SailfishWidgets.Settings 1.3
import harbour.nemosyne.Nemosyne 1.0
import harbour.nemosyne.QmlLogger 2.0

Page {
    property alias ratingVisible: settings.slideRatings
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
                visible: !ratingVisible

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
        spacing: Theme.paddingLarge
        visible: ratingVisible
        x: 0
        y: sf.y
        z: sf.z - 10 //ratingCol should always subordinate to prevent stealing

        Repeater {
            model: [5, 4, 3, 2, 1, 0]
            delegate: PageIndicator {
                property int value: modelData
                page: root
                text: value
                onAccepted: rated(value)

                Component.onCompleted: {
                    ratingCol.width = Math.max(ratingCol.width, contentWidth)
                    pageStack.busyChanged.connect(_reset)
                }

                function _reset() {
                    if(!pageStack || pageStack.busy || pageStack.currentPage != root) return

                    reset() //reset the indicator
                }
            }
        }
    }
}
