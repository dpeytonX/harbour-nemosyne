import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.2

Row{
    property int unmemorized
    property int scheduled
    property int active
    spacing: Theme.paddingMedium

    Column {

        Row {
            spacing: Theme.paddingMedium
            Subtext {
                color: "white"
                text: scheduled
            }

            Subtext {text: qsTr("scheduled")}
        }

        Row {
            spacing: Theme.paddingMedium
            Subtext {
                color: "white"
                text: unmemorized
            }


            Subtext {text: qsTr("unmemorized")}
        }

        Row {
            spacing: Theme.paddingMedium
            Subtext {
                color: "white"
                text: active
            }

            Subtext {text: qsTr("active")}
        }
    }

}
