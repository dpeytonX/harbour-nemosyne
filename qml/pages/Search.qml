import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.QmlLogger 2.0
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.Nemosyne 1.0

Page {
    property Manager manager

    allowedOrientations: Orientation.All
    id: root

    StandardListView {
        anchors.fill: parent

        header: SearchField {
            id: search
            width: parent.width

            onTextChanged: {
                if(text.length >= 3) {
                    Console.info("text = " + text)
                    listModel.update(manager.search(text))
                }
                focus()
            }
        }

        model: ListModel {
            id: listModel

            function update(content) {
                clear()
                for(var i = 0; i < content.length; i++)
                    append(content[i])
            }
        }

        delegate: ListItem {
            width: root.width - Theme.paddingLarge * 2
            x: Theme.paddingLarge

            LabelButton {
                text: model.question;
            }
        }

        VerticalScrollDecorator {}
    }
}
