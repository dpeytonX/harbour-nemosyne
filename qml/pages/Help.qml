import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.Nemosyne 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.SailfishWidgets.FileManagement 1.3

Page {
    readonly property string dataPath: dir.XdgData + "/" + UIConstants.defaultDb

    Dir {id:dir}

    PageColumn {
        title: qsTr("Help")

        SectionHeader {
            text: qsTr("Importing Mnemosyne 2.x Database")
        }

        Paragraph {
            width: parent.width
            text: qsTr("First, copy the mnemosyne.db file from your computer to this device. Then, you may study flash cards here. If you wish, copy the mnemosyne.db back to your computer to resume study there.")
        }
/*
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
        }*/
    }
}
