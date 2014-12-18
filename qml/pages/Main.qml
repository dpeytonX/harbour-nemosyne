import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.Nemosyne 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.SailfishWidgets.FileManagement 1.3
import harbour.nemosyne.SailfishWidgets.Settings 1.3
import harbour.nemosyne.SailfishWidgets.Utilities 1.3
import harbour.nemosyne.QmlLogger 2.0

Page {
    id: main
    property File currentFile

    // ------ SQLite Interface -----------------------

    Manager {
        id:manager
    }

    // ------ Dynamic Object Creation ----------------
    DynamicLoader {
        id: loader

        onObjectCompleted: pageStack.push(object)
    }

    // ------ Dialogs and Misc -----------------------

    Component {
        id: aboutDialog
        AboutPage {
            description: qsTr(UIConstants.appDescription)
            icon: UIConstants.appIcon
            application: UIConstants.appTitle + " " + UIConstants.appVersion
            copyrightHolder: UIConstants.appCopyright
            copyrightYear: UIConstants.appYear
            contributors: UIConstants.appAuthors
            licenses: UIConstants.appLicense
            pageTitle: UIConstants.appTitle
            projectLinks: UIConstants.appProjectInfo
        }
    }

    Component {
        id: fileSelector

        FileSelector {
            property variant referer
            property bool doOpen: false
            signal closed

            acceptDestination: loading
            showNavigationIndicator: status == DialogStatus.Opened


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
                    currentFile = selectedFiles[0]
                    Console.info("Main::openDb: existing file selected " + currentFile.fileName)
                }
            }
        }
    }

    //Not wrapping in Component since it's a pain to use signal connects
    BusyPage {
        id: loading
        title: qsTr("opening database")
        acceptDestination: Component{ Question {} }
        acceptDestinationProperties: {"manager": manager}
        acceptDestinationReplaceTarget: main
        showNavigationIndicator: false

        onOpened: {
            if(!!currentFile) {
                openDb(currentFile, false)
            } else {
                reject()
                errorLabel.text = qsTr("database was not provided")
            }
        }
    }


    // --------- QSettings ----------------------
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

    //------------Page View ----------------------
    SilicaFlickable {
        anchors.fill: parent

        PageColumn {
            id: openColumn
            spacing: Theme.paddingSmall
            title: qsTr("nemosyne")

            Paragraph {
                width: parent.width
                text: qsTr("First, copy the mnemosyne.db file from your computer to this device. Then, you may study flash cards here. If you wish, copy the mnemosyne.db back to your computer to resume study there.")
            }

            Subtext {text: qsTr("Mnemosyne 2.x compatible")}

            Button {
                id: existingDb
                text: qsTr("open existing database")
                onClicked: loader.create(fileSelector, main, {"referer": this})
            }

            Label {
                id: errorLabel
                visible: !!text
            }

            SectionHeader {
                id: recentlyUsed
                text: qsTr("recently used")
                visible: !!recentFile.fileName
            }

            LabelButton {
                color: Theme.primaryColor
                text: recentFile.fileName
                visible: !!text
                onClicked: process(recentFile)
            }

            LabelButton {
                color: Theme.primaryColor
                text: recentFile1.fileName
                visible: !!text
                onClicked: process(recentFile1)
            }

            LabelButton {
                color: Theme.primaryColor
                text: recentFile2.fileName
                visible: !!text
                onClicked: process(recentFile2)
            }

            LabelButton {
                color: Theme.primaryColor
                text: recentFile3.fileName
                visible: !!text
                onClicked: process(recentFile3)
            }
        }

        PullDownMenu  {
            id:pulley
            StandardMenuItem {
                text: qsTr("About")
                onClicked: {
                    loader.create(aboutDialog, main, {})
                }
            }
        }
    }

    //----------Internal Functions---------------


    function process(file) {
        currentFile = file
        loading.open()
    }

    function openDb(file) {
        currentFile = file

        var fileName = currentFile.fileName
        var filePath = currentFile.absoluteFilePath
        Console.info("Main::openDb: existing file selected " + fileName  + " " + filePath)
        var valid = manager.isValidDb(currentFile.absoluteFilePath)

        Console.info("Main::openDb: db is valid " + valid)
        if(valid) {
            errorLabel.text = ""
            if(settings.recentFile == filePath) {
                Console.info("Main::openDb: currentFile is equal to recentFile")
            } else {
                settings.recentFile3 = settings.recentFile2
                settings.recentFile2 = settings.recentFile1
                settings.recentFile1 = settings.recentFile
                settings.recentFile = filePath;
                Console.debug("Main::openDb " + settings.recentFile + " " + filePath)
                Console.debug("after")
                Console.debug("Main::openDb " + settings.recentFile3)
                Console.debug("Main::openDb " + settings.recentFile2)
                Console.debug("Main::openDb " + settings.recentFile1)
                Console.debug("Main::openDb " + settings.recentFile)
            }

            // push new card on page stack
            loading.success()
        } else {
            errorLabel.text = qsTr("database could not be opened")
            loading.failure()
        }
    }
}
