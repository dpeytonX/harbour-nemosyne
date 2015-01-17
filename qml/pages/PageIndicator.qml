import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.3

Flickable {
    property alias text: label.text
    property bool enabled: true
    property bool _hasAccepted: false
    property real _startWidth: width - contentWidth + 50
    property real acceptPoint: _startWidth / 3 * 2
    property variant page: parent
    signal accepted()
    signal rejected()

    id:flicky
    width: page.width
    height: row.height
    interactive: enabled
    opacity: _hasAccepted ? 0 : 1

    contentWidth: row.width
    contentHeight: height
    contentItem.transform: Translate { x: flicky._startWidth }
    flickableDirection: Flickable.HorizontalFlick
    boundsBehavior: Flickable.DragAndOvershootBounds
    maximumFlickVelocity: 1000

    onContentXChanged: {
        if(_hasAccepted) return

        page.opacity = 1 - contentX / acceptPoint

        if(contentX >= acceptPoint) {
            _hasAccepted = true
            accepted()
        } else if(contentX == 0){
            rejected()
        }
    }

    Row {
        id: row
        width: childrenRect.width
        spacing: 0

        InformationalLabel {
            anchors.verticalCenter: parent.verticalCenter
            id: label
            opacity: flicky.enabled ? 1.0 : 0.4
        }

        GlassItem {
            anchors.verticalCenter: parent.verticalCenter
            id: glass
            dimmed: !flicky.enabled
        }
    }

    function reset() { _hasAccepted = false; page.opacity = 1 }
}
