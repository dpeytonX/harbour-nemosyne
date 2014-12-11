import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.nemosyne.QmlLogger 2.0
import harbour.nemosyne.SailfishWidgets.Components 1.2
import harbour.nemosyne.Nemosyne 1.0

Dialog {
    property Manager manager;

    signal next(int rating)

    acceptDestination: Answer {
        onRated: {
            next(rating)
            pageStack.navigateBack()
        }
    }
    acceptDestinationProperties: {"id": "answer", "answer": card.answer}

    Card {id: card}

    PageHeader {id: header; title:""}

    Column {
        anchors.top: header.bottom
        width: parent.width - Theme.paddingLarge * 2
        x: Theme.paddingLarge

        Label {height: parent.height; width: parent.width; text: card.question}
    }

    StatusBar {
        anchors.bottom: parent.bottom
        width: parent.width

        scheduled: manager.scheduled
        active: manager.active
        unmemorized: manager.unmemorized
    }

    Component.onCompleted: next(-1)

    onNext: {
        if(rating !== -1) {
            Console.log("Question: answer was rated: " + rating)
            card.question = "question2"
            card.answer = "answer2"
        } else {
            card.question = "question"
            card.answer = "answer"
        }
    }
}
