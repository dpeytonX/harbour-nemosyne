import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    signal success()
    signal failure()

    property alias running: busy.running
    property alias size: busy.size
    property alias title: heading.text
    property bool moveForward: false
    property variant navigatePage: !!pageStack.find(function(p) { return p == this;}) ? pageStack.previousPage(this) : null

    acceptDestinationReplaceTarget: navigatePage
    acceptDestinationAction: PageStackAction.Replace
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
        if(status == PageStatus.Active) {
            if(moveForward) accept()
            else reject()
            moveForward = false
            canAccept = false
        }
    }

    onSuccess: {
        canAccept = true
        moveForward = true
    }

    onFailure: {
        canAccept = false
        moveForward = false
    }
}
