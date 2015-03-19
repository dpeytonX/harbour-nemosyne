import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.QmlLogger 2.0
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.SailfishWidgets.Utilities 1.3
import harbour.nemosyne.Nemosyne 1.0

Page {
    property Manager manager

    allowedOrientations: Orientation.All
    id: root

    Component {
        id: question
        Question {
            objectName: "question"
            onRejected: _search(pageCol.text)
        }
    }

    Component {
        id: card
        Card {}
    }

    ListModel {
        id: listModel

        function update(content) {
            clear()

            for(var i = 0; i < content.length; i++) {
                Console.trace("update: " + content[i].question)
                append(content[i])
            }
        }
    }

    DynamicLoader {
        id: loader

        onObjectCompleted: {
            Console.debug("objectName: " + object.objectName)
            if(object.objectName === "card") {
                loader.create(question, root, {"manager": manager, "card": object, "viewOnly": true})
            } else {
                pageStack.push(object)
            }
        }

        onError: {
            Console.error("Search: " + errorString)
        }
    }

    PageColumn {
        property alias text: search.text
        id: pageCol
        title: qsTr("Search")
        z: 1000

        SearchField {
            id: search
            width: parent.width
            z:1000

            onTextChanged: _search(text)
        }
    }


    StandardListView {
        anchors.topMargin: Theme.paddingLarge * 2
        anchors.top: pageCol.bottom
        anchors.bottom: root.bottom
        width: root.width - Theme.paddingLarge * 2
        x: Theme.paddingLarge
        z: 0

        model: listModel

        delegate: ListItem {
            z: 10
            anchors.topMargin: Theme.paddingSmall
            anchors.bottomMargin: Theme.paddingSmall
            width: parent.width

            InformationalLabel {
                maximumLineCount: 1

                text: model.question;
                truncationMode: TruncationMode.Fade
            }
            onClicked: {
                var m = model
                m.objectName = "card"
                Console.info("card clicked: " + m.question)
                loader.create(card, root, m)
            }
        }


        VerticalScrollDecorator {}
    }

    /*!
      \internal
    */
    function _search(text) {
        Console.debug("search text = " + text)
        if(text.length >= 3) {
            listModel.update(manager.search(text))
        } else if(text.length === 0) {
            listModel.update([])
        }
    }
}
