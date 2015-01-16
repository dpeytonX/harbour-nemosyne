import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.SailfishWidgets.Settings 1.3
import harbour.nemosyne.Nemosyne 1.0

Page {
    property string answer

    signal rated(int rating)

    objectName: "answer"

    ApplicationSettings {
        id: settings
        applicationName: "harbour-nemosyne"
        fileName: "settings"

        property int defaultFontSizeId: 0
    }

    FontHandler {id: fh}

    SilicaFlickable {
        anchors.fill: parent

        PageHeader {id: header; title:""}

        Column {
            anchors.top: header.bottom
            width: parent.width - Theme.paddingLarge * 2
            x: Theme.paddingLarge
            Paragraph {
                color: Theme.primaryColor
                width: parent.width;
                font.pixelSize: fh.fontIndices[settings.defaultFontSizeId]
                text: answer
            }

            Component {
                id: pushMenuItem
                StandardMenuItem {
                    property int value
                    onClicked: rated(value)
                }
            }

            PushUpMenu {
                id: pushMenu

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
}
