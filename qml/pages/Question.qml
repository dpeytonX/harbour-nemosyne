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
    canAccept: !!card
    acceptDestination: Answer {
        answer: !!card ? card.answer : ""
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

    Component {
        id: cardDetailPage

        CardDetail {
            onAccepted: {
                if(objectName == "addCard") {
                    _addCard()
                } else if(objectName == "editCard") {
                    _editCard()
                }
            }

            function _addCard() {
                manager.addCard(cardType, questionText, answerText)
                if(!card) _next()
                Console.log("card added")
                manager.initTrackingValues()
            }

            function _editCard() {
                card.question = questionText
                card.answer = answerText
                manager.saveCard()
                Console.log("card editted")
                manager.initTrackingValues()
            }
        }
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
                text: !!card ? card.question : ""
            }
        }

        PullDownMenu  {
            id: cardOps

            StandardMenuItem {
                text: qsTr("Add Card(s)")

                onClicked: {
                    Console.info("Add card selected")
                    loader.create(cardDetailPage, questionPage, {
                                      "objectName": "addCard"
                                  })
                }
            }

            StandardMenuItem {
                text: qsTr("Edit")
                visible: canAccept

                onClicked: {
                    loader.create(cardDetailPage, questionPage, {
                                      "cardOperation": CardOperations.EditOperation,
                                      "questionText": question,
                                      "answerText": answer,
                                      "objectName": "editCard"
                                  })
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
        if(rating == null) {
            rating = -1
        }

        manager.next(rating)
        Console.log("Question: card is " + card)
    }

    onManagerChanged: {
        if(!!manager) {
            manager.deleteCard.connect(_next)
        }
    }


    function _next() {next(-1);}
}
