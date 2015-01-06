import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.Nemosyne 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.SailfishWidgets.Settings 1.3

/*!
  \qmltype AddCard

  Presents the user with two editable text areas for the question and answer of a flash card.
  */
Dialog {
    id: cardDetails
    property alias answerText: answer.text
    property alias questionText: question.text
    property alias cardType: combo.currentIndex
    property int cardOperation: CardOperations.AddOperation

    anchors.leftMargin: Theme.paddingLarge
    anchors.rightMargin: Theme.paddingLarge
    canAccept: !!questionText && !!answerText

    ApplicationSettings {
        id: settings
        applicationName: "harbour-nemosyne"
        fileName: "settings"

        property int lastCardType: 0
    }

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
                currentIndex: settings.lastCardType
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
                visible: cardOperation == CardOperations.AddOperation
                onCurrentIndexChanged: settings.lastCardType = currentIndex
            }

            TextArea {
                id: question
                label: qsTr("Question")
                placeholderText: label
                width: detailCol.width
                softwareInputPanelEnabled: status == DialogStatus.Opened
            }

            // The separator is here so that the user can close the keyboard when
            // the text area is too unwieldy to scroll through.
            Spacer {}
            Separator { width: parent.width / 2; color: Theme.secondaryHighlightColor }
            Spacer {}

            TextArea {
                id: answer
                label: qsTr("Answer")
                placeholderText: label
                width: detailCol.width
                softwareInputPanelEnabled: status == DialogStatus.Opened
            }
        }
        VerticalScrollDecorator {}
    }
}
