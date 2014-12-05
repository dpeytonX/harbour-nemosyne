import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.nemosyne.QmlLogger 2.0
import harbour.nemosyne.SailfishWidgets.Utilities 1.2

/*
  This is a page that will hold either a question or answer card in a lazy loaded component element

  It will manage how many cards to go through and when to display each.

  The individual display (i.e. Question or Answer) will be controlled by the child component.

  Interfaces with the database.

  Will have a pull down setting menu
 */
Page {
    property bool isQuestion: false
    signal next

    Component.onCompleted: next()

    onNext: {
        if(isQuestion) {
            //showAnswer
        } else {
            loader.create(Qt.createComponent(Qt.resolvedUrl("Question.qml")), this, {})
        }
    }

    DynamicLoader {
        id: loader

        onObjectCompleted: {
            object.anchors.fill = object.parent
            isQuestion != isQuestion
        }

        onError: {
            Console.error(errorString)
        }
    }
}
