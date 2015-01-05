import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.QmlLogger 2.0
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.SailfishWidgets.Utilities 1.3
import harbour.nemosyne.Nemosyne 1.0

Dialog {
    id: questionPage
    property alias question: questionLabel.text
    property alias answer: answerCard.answer
    property Manager manager;
    property Card card: !!manager ? manager.card : null;

    signal next(int rating)

    objectName: "question"

    acceptDestination: Answer {
        id: answerCard
        onRated: {
            next(rating)
            pageStack.navigateBack()
        }

        Component.onCompleted: next(-1)
    }

    DynamicLoader {
        id: loader
        onObjectCompleted: pageStack.push(object)
    }

    RemorsePopup {
        id: remorse
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: pageCol.height

        PageColumn {
            id: pageCol
            //anchors.top: header.bottom
            title: ""

            Paragraph {
                color: Theme.primaryColor
                id: questionLabel;
                width: parent.width;
            }
        }

        PullDownMenu  {
            id: cardOps

            StandardMenuItem {
                text: qsTr("Add Card(s)")

                onClicked: {
                    Console.info("Add card selected")
                    loader.create(Qt.createComponent("CardDetail.qml"), questionPage, {})
                }
            }

            StandardMenuItem {
                text: qsTr("Edit")
                visible: canAccept

                onClicked: {
                    Console.info("Edit card selected")
                }
            }

            StandardMenuItem {
                text: qsTr("Delete")
                visible: canAccept

                onClicked: {
                    remorse.execute(qsTr("Deleting card"), manager.deleteCard)
                }
            }
        }

        VerticalScrollDecorator {}
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        visible: !canAccept

        InformationalLabel {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("No cards")
        }

        Subtext {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Add cards to begin")
        }
    }

    StatusBar {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingLarge
        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingLarge
        width: parent.width - Theme.paddingLarge * 2
        visible: canAccept

        scheduled: manager.scheduled
        active: manager.active
        unmemorized: manager.unmemorized
    }

    onNext: {
        Console.log("Question: answer was rated: " + rating)
        if(rating === undefined) {
            rating = -1
        }

        manager.next(rating)
        Console.log("Question: card is " + card)
        if(!card) {
            canAccept = false
            return
        }
        canAccept = true

        question = card.question
        answer = card.answer
    }

    onManagerChanged: {
        if(!!manager) {
            manager.deleteCard.connect(_next)
        }
    }

    function _next() {next(-1);}
}
