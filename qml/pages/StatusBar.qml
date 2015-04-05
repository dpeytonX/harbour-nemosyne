import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.3

Row{
    property int unmemorized
    property int scheduled
    property int active
    spacing: Theme.paddingMedium
    id: root

    Column {

        Row {
            spacing: Theme.paddingMedium

            Subtext {
                text: qsTr("scheduled")
                width: Math.min(500, root.width * .6)
            }

            Subtext {
                color: "white"
                text: scheduled
            }
        }

        Row {
            spacing: Theme.paddingMedium

            Subtext {
                text: qsTr("unmemorized")
                width: Math.min(500, root.width * .6)
            }

            Subtext {
                color: "white"
                text: unmemorized
            }
        }

        Row {
            spacing: Theme.paddingMedium

            Subtext {
                text: qsTr("active")
                width: Math.min(500, root.width * .6)
            }

            Subtext {
                color: "white"
                text: active
            }
        }
    }

}
