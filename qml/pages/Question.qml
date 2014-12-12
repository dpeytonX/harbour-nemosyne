import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.nemosyne.QmlLogger 2.0
import harbour.nemosyne.SailfishWidgets.Components 1.2
import harbour.nemosyne.Nemosyne 1.0

Dialog {
    property alias question: questionLabel.text
    property alias answer: answerCard.answer
    property Manager manager;
    property Card card;

    signal next(int rating)

    acceptDestination: Answer {
        id: answerCard
        onRated: {
            next(rating)
            pageStack.navigateBack()
        }

        Component.onCompleted: next(-1)
    }

    PageHeader {id: header; title:""}

    Column {
        anchors.top: header.bottom
        width: parent.width - Theme.paddingLarge * 2
        x: Theme.paddingLarge

        Label {
            id: questionLabel;
            height: parent.height;
            width: parent.width;
        }
    }

    InformationalLabel {
        anchors.centerIn: parent
        visible: !canAccept
        text: qsTr("No more cards")
    }

    StatusBar {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingLarge
        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingLarge
        width: parent.width - Theme.paddingLarge * 2

        scheduled: manager.scheduled
        active: manager.active
        unmemorized: manager.unmemorized
    }

    onNext: {
        Console.log("Question: answer was rated: " + rating)
        card = manager.next(rating);
        if(card == null) {
            canAccept = false
            return
        }
        canAccept = true

        question = card.question
        answer = card.answer
    }
}
