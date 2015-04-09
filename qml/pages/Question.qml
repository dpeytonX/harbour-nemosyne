/***************************************************************************
** This file is part of Nemosyne
**
** Copyright (c) 2015 Dametrious Peyton
**
** $QT_BEGIN_LICENSE:GPLV3$
** SailfishWidgets is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** SailfishWidgets is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with SailfishWidgets.  If not, see <http://www.gnu.org/licenses/>.
** $QT_END_LICENSE$
**
**************************************************************************/

import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.QmlLogger 2.0
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.SailfishWidgets.Utilities 1.3
import harbour.nemosyne.SailfishWidgets.Settings 1.3
import harbour.nemosyne.Nemosyne 1.0

/**
  TODO: Consider breaking Question into a ViewOnly vs Testable hierarchy
  */
Dialog {
    property alias question: questionLabel.text
    property alias answer: answerCard.answer
    property bool viewOnly: false
    property Manager manager;
    property Settings settingsPage;
    property Card card: !!manager ? manager.card : null;

    signal next(int rating)

    allowedOrientations: Orientation.All
    id: questionPage
    objectName: "question"
    canAccept: !!card
    acceptDestination: Answer {
        answer: !!card ? card.answer : ""
        id: answerCard
        viewOnly: questionPage.viewOnly
        onRated: {
            next(rating)
            pageStack.navigateBack()
        }

        Component.onCompleted: next(-1)
    }

    ApplicationSettings {
        id: settings
        applicationName: "harbour-nemosyne"
        fileName: "settings"

        property int defaultFontSizeId: 0
        property string timeText: "00:00"

        onTimeTextChanged: _next()
    }

    DynamicLoader {
        id: loader
        onObjectCompleted: pageStack.push(object)
    }

    Component {
        id: cardDetailPage

        CardDetail {
            onAccepted: {
                if(objectName == "addCard")
                    _addCard()
                else if(objectName == "editCard")
                    _editCard()
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
                manager.saveCard(card)
                Console.log("card editted")
                manager.initTrackingValues()
            }
        }
    }

    FontHandler { id: fh }

    RemorsePopup { id: remorse }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: pageCol.height

        PageColumn {
            id: pageCol
            title: ""

            Paragraph {
                color: Theme.primaryColor
                id: questionLabel;
                font.pixelSize: fh.fontIndices[settings.defaultFontSizeId]
                width: parent.width;
                text: !!card ? card.question : ""
            }
        }

        PullDownMenu  {
            id: cardOps

            StandardMenuItem {
                enabled: !viewOnly
                visible: !viewOnly
                text: qsTr("Search")

                onClicked: {
                    Console.info("Search selected")
                    loader.create(Qt.createComponent("Search.qml"), questionPage, {"manager": manager})
                }
            }

            StandardMenuItem {
                enabled: !viewOnly
                visible: !viewOnly
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

                onClicked: remorse.execute(qsTr("Deleting card"), _delete)
            }
        }

        PushUpMenu {
            id: pushy

            StandardMenuItem {
                text: qsTr("Settings")
                onClicked: {
                    Console.debug("Settings clicked")
                    pageStack.push(settingsPage)
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
        visible: canAccept && !pushy.active && !viewOnly
        z: -100

        scheduled: manager.scheduled
        active: manager.active
        unmemorized: manager.unmemorized
    }

    onNext: {
        Console.log("Question: answer was rated: " + rating)
        if(rating == null)
            rating = -1

        manager.next(rating)
        Console.log("Question: card is " + card)
    }

    onManagerChanged: {
        if(!!manager)
            manager.cardDeleted.connect(_deleted)
    }


    function _next() { next(-1); }

    function _delete() { manager.deleteCard(card) }

    function _deleted() {
        if(viewOnly)
            reject()
        else
            _next()
    }
}
