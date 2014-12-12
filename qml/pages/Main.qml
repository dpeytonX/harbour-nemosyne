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
    property File currentFile

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

        Subtext {
            anchors.right: parent.right
            text: qsTr("mobile flash cards")
        }

        Heading {
            text: qsTr("open existing database")
            font.underline: true
        }

        Subtext {text: qsTr("Mnemosyne 2.x compatible")}

        Button {
            id: existingDb
            text: qsTr("search")
            onClicked: {
                fileSelector.referer = this
                fileSelector.open()
            }
        }

        Label {
            id: errorLabel
            visible: !!text
        }
    }

    PageColumn {
        title: null
        anchors.bottom: parent.bottom

        Spacer {visible: recentlyUsed.visible}

        Heading {
            id: recentlyUsed
            text: qsTr("recently used")
            visible: !!recentFile.fileName
            font.underline: true
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
    }

    BusyPage {
        id: loading
        title: qsTr("opening database")
        acceptDestination: Component{ Question {} }
        acceptDestinationProperties: {"manager": manager}
    }

    FileSelector {
        property variant referer
        property bool doOpen: false
        signal closed

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
                doOpen = true
            }
        }

        Component.onCompleted: {
            pageStack.busyChanged.connect(statusCheck)
        }

        function statusCheck() {
            Console.log("mystats " + status + " " + DialogStatus.Closed)
            if(status != DialogStatus.Closed || pageStack.busy) return
            if(doOpen) {
                doOpen = false
                openDb(selectedFiles[0])
            }
        }
    }

    Manager {
        id:manager
    }

    function openDb(file) {
        currentFile = file

        loading.open()
        Console.info("Main::openDb: existing file selected " + currentFile.fileName)
        var valid = manager.isValidDb(currentFile.absoluteFilePath)
        Console.info("Main::openDb: db is valid " + valid)
        if(valid) {
            errorLabel.text = ""
            //TODO: keep history tracking
            settings.recentFile = currentFile.absoluteFilePath
            // push new card on page stack
            loading.success()
        } else {
            errorLabel.text = qsTr("database could not be opened")
            loading.failure()
        }
    }
}
