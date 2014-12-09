import QtQuick 2.0

InformationalLabel {
    signal clicked(variant mouse)

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: parent.clicked(mouse)
    }
}
