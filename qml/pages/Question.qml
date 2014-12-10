import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.nemosyne.QmlLogger 2.0
import harbour.nemosyne.SailfishWidgets.Components 1.2

Dialog {
    acceptDestination: Answer {
        onRated: {
            card.question = "question2"
            card.answer = "answer2"
            Console.log("Question: answer was rated: " + rating)
            pageStack.navigateBack()
        }
    }
    acceptDestinationProperties: {"id": "answer", "answer": card.answer}

    Card {
        id: card
        question: "question"
        answer: "answer"
    }

    PageHeader {id: header; title:""}

    Column {
        anchors.top: header.bottom
        width: parent.width - Theme.paddingLarge * 2
        x: Theme.paddingLarge

        Label {height: parent.height; width: parent.width; text: card.question}
    }
}
