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
import harbour.nemosyne.SailfishWidgets.Components 1.4
import harbour.nemosyne.SailfishWidgets.Utilities 1.4
import harbour.nemosyne.Nemosyne 1.0

Page {
    property Manager manager
    property int count: 0
    property var results: []

    allowedOrientations: Orientation.All
    objectName: "search"
    id: root

    Component {
        id: question
        Question {
            objectName: "question"
            onRejected: {
                listModel.clear()
                _search(pageCol.text)
            }
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
        placeHolderText: ""
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
            var content = manager.search(text)
            results = []
            for(var i = 0; i < content.length; i++) {
                results.push(content[i].question)
            }

            count = results.length
            listModel.update(content)
        } else if(text.length === 0) {
            results = []
            count = results.length
            listModel.update([])
        }
    }
}
