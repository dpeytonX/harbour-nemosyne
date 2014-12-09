import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.2

Page {
    property string answer

    signal rated(int rating)

    Component {
        id: pushMenuItem
        StandardMenuItem {
            property int value
            onClicked: rated(value)
        }
    }

    SilicaFlickable {
        anchors.fill: parent

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

        PageColumn {
            Label {height: parent.height; width: parent.width; text: answer}
        }
    }
}
