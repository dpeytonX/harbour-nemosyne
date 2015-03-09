import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    SilicaListView {
        anchors.fill: parent

        header: SearchField {
            width: parent.width
        }

        VerticalScrollDecorator {}
    }
}
