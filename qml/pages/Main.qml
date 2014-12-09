import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.nemosyne.Nemosyne 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.2
import harbour.nemosyne.SailfishWidgets.FileManagement 1.2
import harbour.nemosyne.SailfishWidgets.Settings 1.2
import harbour.nemosyne.QmlLogger 2.0

/**
  a) Open DB file
  b) If DB not available, show file search
  **/
Page {
    signal openDb(File file)

    ApplicationSettings {
        id: settings
        applicationName: "harbour-nemosyne"
        fileName: "settings"

        property bool openRecent: true
        property string recentFile: ""
        property string recentFile1: ""
        property string recentFile2: ""
        property string recentFile3: ""
    }

    File {id: recentFile}
    File {id: recentFile1}
    File {id: recentFile2}
    File {id: recentFile3}

    Binding {target: recentFile; property: "fileName"; value: settings.recentFile}
    Binding {target: recentFile1; property: "fileName"; value: settings.recentFile1}
    Binding {target: recentFile2; property: "fileName"; value: settings.recentFile2}
    Binding {target: recentFile3; property: "fileName"; value: settings.recentFile3}

    PageColumn {
        spacing: Theme.paddingSmall
        title: qsTr("nemosyne")

        InformationalLabel {
            anchors.right: parent.right
            text: qsTr("mobile flash cards")
        }

        Heading {
            id: recentlyUsed
            text: qsTr("recently used")
            visible: !!recentFile.fileName
        }

        LabelButton {
            text: recentFile.fileName
            visible: !!text
            onClicked: openDb(recentFile)
        }

        LabelButton {
            text: recentFile1.fileName
            visible: !!text
            onClicked: openDb(recentFile1)
        }

        LabelButton {
            text: recentFile2.fileName
            visible: !!text
            onClicked: openDb(recentFile2)
        }

        LabelButton {
            text: recentFile3.fileName
            visible: !!text
            onClicked: openDb(recentFile3)
        }

        Spacer {
            visible: recentlyUsed.visible
        }

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
        selectedFiles: [recentFile]

        onAccepted: {
            if(referer == null || selectedFiles.length != 1)
                return;

            Console.info("Main::referer: " + selectedFiles[0].absoluteFilePath)
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
            //TODO: keep history tracking
            settings.recentFile = file.absoluteFilePath
            // push new card on page stack
            pageStack.pop(this, PageStackAction.Immediate)
            pageStack.push("Card.qml")
        }
    }
}
