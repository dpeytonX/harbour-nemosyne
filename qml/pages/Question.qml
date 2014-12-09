import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.nemosyne.QmlLogger 2.0
import harbour.nemosyne.SailfishWidgets.Components 1.2

Dialog {
    property Card card

    acceptDestination: answer

    Answer {
        id: answer

        answer: card.answer

        onRated: {
            card.question = "question2"
            card.answer = "answer2"
            Console.log("Question: answer was rated: " + rating)
            pageStack.navigateBack()
        }
    }

    PageColumn {
        Label {height: parent.height; width: parent.width; text: card.question}
    }
}
