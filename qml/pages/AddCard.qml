import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.3

/*!
  \qmltype AddCard

  Presents the user with two editable text areas for the question and answer of a flash card.

  TODO: maybe make this a generic card editor page
  TODO: add card type combo field
  */
Dialog {
    id: cardDetails
    property alias answerText: answer.text
    property alias questionText: question.text
    property alias cardType: combo.currentIndex
    property int addOperation: 0
    property int editOperation: 1
    property int cardOperation: addOperation

    anchors.leftMargin: Theme.paddingLarge
    anchors.rightMargin: Theme.paddingLarge

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: detailCol.height + header.height

        DialogHeader {
            id: header
            title: qsTr("Card Details")
        }

        Column {
            anchors.top: header.bottom
            anchors.topMargin: Theme.paddingLarge
            width: parent.width - Theme.paddingLarge*2
            x: Theme.paddingLarge
            id: detailCol

            ComboBox {
                id: combo
                label: qsTr("Card Type")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Front To Back")
                    }
                    MenuItem {
                        text: qsTr("Front to Back, Back to Front")
                    }
                }
                visible: cardOperation == addOperation
            }

            TextArea {
                id: question
                label: qsTr("Question")
                placeholderText: label
                width: detailCol.width
            }

            // The separator is here so that the user can close the keyboard when
            // the text area is too unwieldy to scroll through.
            Separator { width: parent.width / 2; color: Theme.secondaryHighlightColor }

            TextArea {
                id: answer
                label: qsTr("Answer")
                placeholderText: label
                width: detailCol.width
            }
        }
        VerticalScrollDecorator {}
    }
}
