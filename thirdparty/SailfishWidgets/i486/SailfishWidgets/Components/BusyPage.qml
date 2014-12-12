import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property alias running: busy.running
    property alias size: busy.size
    property alias title: heading.text
    property variant previousPage: !!pageStack.find(function(p) { return p == this;}) ? pageStack.previousPage(this) : null

    signal finish()

    acceptDestinationAction: PageStackAction.Replace
    acceptDestinationReplaceTarget: previousPage
    canAccept: false
    showNavigationIndicator: false

    Heading {
        anchors.bottom: busy.top
        anchors.bottomMargin: Theme.paddingLarge
        anchors.horizontalCenter: parent.horizontalCenter
        id: heading
    }

    BusyIndicator {
        anchors.centerIn: parent
        id: busy
        running: status == PageStatus.Activating || status == PageStatus.Active
        size: BusyIndicatorSize.Large
    }

    onStatusChanged: {
        if(status == PageStatus.Active) accept()
    }

    onFinish: canAccept = true
}
