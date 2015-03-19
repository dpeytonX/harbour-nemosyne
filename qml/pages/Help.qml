import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.Nemosyne 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.SailfishWidgets.FileManagement 1.3

Page {
    allowedOrientations: Orientation.All
    readonly property string dataPath: dir.XdgData + "/" + UIConstants.defaultDb

    Dir {id:dir}

    //TODO: make a flickable column widget
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: header.height + contentCol.childrenRect.height

        PageHeader {
            id: header
            title: qsTr("Help")
        }

        Column {
            id: contentCol
            anchors.top: header.bottom
            width: parent.width - Theme.paddingLarge * 2
            x: Theme.paddingLarge

            SectionHeader {
                text: qsTr("Importing Mnemosyne 2.x Database")
            }

            Paragraph {
                width: parent.width
                text: qsTr("First, copy the mnemosyne.db file from your computer to this device. Then, you may study flash cards here. If you wish, copy the mnemosyne.db back to your computer to resume study there.")
            }

            SectionHeader {
                text: qsTr("Starting a New Database")
            }

            Paragraph {
                width: parent.width
                text: qsTr("New databases will be created at the following path: ")
            }

            Paragraph {
                width: parent.width
                text: dataPath
            }

            SectionHeader {
                text: qsTr("Rating")
            }

            Paragraph {
                width: parent.width
                text: qsTr("Score cards by providing a rating from 0 to 5. A rating of 0 indicates that you do not recall ever seeing the card. Whereas, a rating of 5 indicates complete recognition. Your score will determine how frequently a card re-appears in subsequent trainings.")
            }

            SectionHeader {
                text: qsTr("Search")
            }

            Paragraph {
                width: parent.width
                text: qsTr("You may search through your card database by typing the search term in the tool bar. Matching cards will be displayed in a list view. Clicking an entry will bring up the question and answer texts.")
            }
        }
    }
}
