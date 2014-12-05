import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.nemosyne.Nemosyne 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.2
import harbour.nemosyne.SailfishWidgets.FileManagement 1.2
import harbour.nemosyne.QmlLogger 2.0

/**
  a) Open DB file
  b) If DB not available, show file search

  //TODO: I need to add absolutePath as QPROPERTY of File in FileManagement
  **/
Page {
    signal openDb(File file)

    PageColumn {
        spacing: Theme.paddingSmall
        title: qsTr("nemosyne")

        InformationalLabel {
            anchors.right: parent.right
            text: qsTr("mobile flash cards")
        }


/*
        Heading {
            id: myLabel
            text: qsTr("recently used")
        }

        //TODO: use filemanagement
        //clicking on recently used file will attempt to open it

        InformationalLabel {text: "nemosyne.db"}
        InformationalLabel {text: "nemosyne1.db"}
*/


        Heading {
            text: qsTr("open existing database")
        }
        Subtext {
            text: qsTr("Mnemosyne 2.x compatible")
        }
        Button {
            id: existingDb
            text: qsTr("search")
            onClicked: {
                fileSelector.referer = this
                fileSelector.open()
            }
        }

        /*
        InformationalLabel {
            text: qsTr("new database")
        }
        Button {
            text: qsTr("search...")
        }*/
    }

    FileSelector {
        property variant referer
        id: fileSelector

        acceptText: qsTr("select database")
        deselectText: qsTr("deselect")
        selectText: qsTr("select")
        multiSelect: false
        selectionFilter: Dir.Files | Dir.Readable | Dir.Writable

        onAccepted: {
            if(referer == null || selectedFiles.length != 1)
                return;

            if(referer == existingDb) {
                openDb(selectedFiles[0])
            }
        }
    }

    Manager {
        id:manager
    }

    onOpenDb: {
        Console.info("Main::openDb: existing file selected " + file.fileName)
        var valid = manager.isValidDb(file.absoluteFilePath)
        Console.info("Main::openDb: db is valid " + valid)
        if(valid) {
            // push new card on page stack
            pageStack.pop(this, PageStackAction.Immediate)
            pageStack.push("Card.qml")
        }
    }
}
