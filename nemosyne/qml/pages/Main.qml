/***************************************************************************
** This file is part of Nemosyne
**
** Copyright (c) 2015 Dametrious Peyton
**
** $QT_BEGIN_LICENSE:GPLV3$
** SailfishWidgets is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** SailfishWidgets is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with SailfishWidgets.  If not, see <http://www.gnu.org/licenses/>.
** $QT_END_LICENSE$
**
**************************************************************************/

import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.Nemosyne 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.4
import harbour.nemosyne.SailfishWidgets.FileManagement 1.4
import harbour.nemosyne.SailfishWidgets.Settings 1.4
import harbour.nemosyne.SailfishWidgets.Utilities 1.4
import harbour.nemosyne.QmlLogger 2.0

/**
  The standard workflow of this dialog is as follows.

  User clicks on a database.
  The database has file system checks performed in the process method.
  The process method opens the BusyPage busy component.
  The onOpened signal calls the openDb method which uses Manager.validateDatabase() to perform more checks.
  Manager performs SQL validation on the database.
  Once complete manager.onDatabaseValid is called with the final validation status
  Lastly, the busy component is then proceeds to the first Question or is popped of the stack to return to Main.
 */
OrientationPage {
    readonly property string dataPath: dir.XdgData + "/" + UIConstants.defaultDb
    property bool openQuickly: false
    property File currentFile

    id: main
    objectName: "main"

    // ------ SQLite Interface -----------------------

    Manager {
        id:manager

        onDatabaseValid: {
            Console.info("Main::openDb: db is valid " + valid)
            if(valid) {
                errorLabel.text = ""
                var filePath = currentFile.absoluteFilePath
                if(settings.recentFile == filePath) {
                    Console.info("Main::openDb: currentFile is equal to recentFile")
                } else {
                    var t = Date.now()
                    Console.info("Main::openDb: reset history " + t)
                    settings.recentFile3 = settings.recentFile2
                    settings.recentFile2 = settings.recentFile1
                    settings.recentFile1 = settings.recentFile
                    settings.recentFile = filePath;
                    // Remove duplicates
                    _cleanHistory()

                    Console.debug("Main::openDb " + settings.recentFile + " " + filePath)
                    Console.debug("after")
                    Console.debug("Main::openDb " + settings.recentFile3)
                    Console.debug("Main::openDb " + settings.recentFile2)
                    Console.debug("Main::openDb " + settings.recentFile1)
                    Console.debug("Main::openDb " + settings.recentFile)
                    Console.info("Main::openDb: reset history took " + (Date.now() - t) + "ms")
                }

                // --------> This will eventually open a Question/Answer component and push it into the view
                if(openQuickly)
                    loader.create(busy.acceptDestination, main, busy.acceptDestinationProperties)
                else
                    busy.success()
            } else {
                errorLabel.text = qsTr("database could not be opened")
                if(!openQuickly) busy.failure()
            }
        }
    }

    // ------ Dynamic Object Creation ----------------
    DynamicLoader {
        id: loader

        onObjectCompleted: pageStack.push(object)
    }

    // ------ Dialogs and Misc -----------------------

    RemorsePopup {
        id: remorse
    }

    Component {
        id: aboutDialog
        AboutPage {
            description: qsTr("A mobile flash card tool")
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
        id: newDbDialog
        Dialog {
            DialogHeader {
                title: qsTr("This action will delete the pre-existing database. Are you sure?")
            }

            onAccepted: {
                remorse.execute(qsTr("Deleting old database"), function() {
                    Console.info("initialize: file " + newFile.absoluteFilePath + "already exists. will delete")
                    var result = newFile.remove()
                    Console.info("initialize: file deleted " + result)

                    create()
                })
            }
        }
    }

    Component {
        id: fileSelector

        FileSelector {
            property variant referer
            property bool doOpen: false
            signal closed

            acceptDestination: busy
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

    Settings {
        id: settingsPage
    }

    /*
      This is the work horse of Main.qml. This will create the Question component in the property
      "acceptDestination" and pass the manager (the database access layer) and Settings page to it.

      The success() signal, see manager.onDatabaseValid, when called will open the Question component
      which shows the next card to be reviewed on the stack.

      The failure() signal will close the BusyPage and return to Main.
    */
    BusyPage {
        id: busy
        title: qsTr("opening database")
        acceptDestination: Component{ Question {  } }
        acceptDestinationProperties: {"manager": manager, "settingsPage": settingsPage}
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

        property bool autoOpenDb: false
        property string recentFile: ""
        property string recentFile1: ""
        property string recentFile2: ""
        property string recentFile3: ""
    }

    Dir {id: dir}
    File {id: newFile; fileName: dataPath}
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
        contentHeight: openColumn.height

        VerticalScrollDecorator {}

        PageColumn {
            id: openColumn
            spacing: Theme.paddingSmall
            title: qsTr("nemosyne")

            Subtext {text: qsTr("Mnemosyne 2.x compatible")}

            Button {
                id: existingDb
                text: qsTr("open existing database")
                onClicked: loader.create(fileSelector, main, {"referer": this})
            }

            Spacer {}

            Button {
                id: newDb
                text: qsTr("new db")
                onClicked: {
                    if(newFile.exists) // Open the "overwrite existing DB?" remorse dialog
                        loader.create(newDbDialog, main, {})
                    else // Otherwise, create the new database file
                        create()
                }
            }

            Spacer{}


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
                text: qsTr("Help")
                onClicked: loader.create(Qt.createComponent("Help.qml"), main, {})
            }

            StandardMenuItem {
                text: qsTr("About")
                onClicked: loader.create(aboutDialog, main, {})
            }
        }

        PushUpMenu {
            id: pushy

            StandardMenuItem {
                text: qsTr("Settings")
                onClicked: {
                    Console.debug("Settings clicked")
                    pageStack.push(settingsPage)
                }
            }
        }
    }

    Component.onCompleted: {
        _cleanHistory()
        pageStack.busyChanged.connect(autoRun)
        pageStack.currentPageChanged.connect(autoRun)
        statusChanged.connect(autoRun)
    }

    //----------Internal Functions---------------

    /*!
      \internal

      This function forces the last used database into view provided the correct settings are enabled
      and the Page Stack is idle.

      See Component.onCompleted and process()
      */
    function autoRun() {
        Console.debug("pagestack animating: " + pageStack.acceptAnimationRunning)
        Console.debug("pagestack busy: " + pageStack.busy)
        Console.debug("pagestack page: " + pageStack.currentPage)
        Console.debug("pagestack active: " + main.status)
        if(main.status == PageStatus.Active && !pageStack.busy && pageStack.currentPage == main && settings.autoOpenDb && !!recentFile) {
            Console.info("Main: auto opening " + recentFile.absoluteFilePath)
            statusChanged.disconnect(autoRun)
            pageStack.busyChanged.disconnect(autoRun)
            pageStack.currentPageChanged.disconnect(autoRun)
            process(recentFile, true)
        }
    }

    /*!
      \internal

      Determines whether to open the last used database or to hand off the database to the Busy page
      */
    function process(file, quickly) {
        if(quickly !== undefined && quickly) {
            currentFile = file
            if(!!currentFile) {
                openDb(currentFile, true)
            } else {
                errorLabel.text = qsTr("database was not provided")
            }
        } else {
            currentFile = file
            busy.open()
        }
    }

    /*!
      \internal

      Gets the path to the database and uses Manager to validate it.

      See manager.onDatabaseValid property change listener
      */
    function openDb(file, quickly) {
        main.openQuickly = quickly !== undefined ? quickly : false
        currentFile = file

        var fileName = currentFile.fileName
        var filePath = currentFile.absoluteFilePath
        Console.info("Main::openDb: existing file selected " + fileName  + " " + filePath)
        manager.validateDatabase(currentFile.absoluteFilePath)
    }

    function create() {
        Console.info("new database requested")
        Console.info("creating db at " + dataPath)

        if(manager.create(dataPath)) {
            if(manager.initialize()) {
                process(newFile)
            } else {
                errorLabel.text = qsTr("database could not be initialized")
            }
        } else {
            errorLabel.text = qsTr("database could not be opened")
        }
    }

    /*!
      \internal

      This cleans up duplicate history items from a previous version of Nemosyne. May be deleted in the future.
      */
    function _cleanHistory() {
        //Cleanup settings from V 1.0
        var t = Date.now()
        Console.debug("cleanHistory: start " + t)
        var files = [settings.recentFile, settings.recentFile1, settings.recentFile2, settings.recentFile3]

        for(var i = 0; i < files.length; i++) {
            if(files[i] == "") continue;
            for(var j = i+1; j < files.length; j++) {
                if(files[i] == files[j]) {
                    Console.debug("i (" + i + ") and (" + j + ") j are duplicates")
                    files[j] = j == files.length - 1 ? "" : files[j+1]
                }
            }
        }
        settings.recentFile = files[0]
        settings.recentFile1 = files[1]
        settings.recentFile2 = files[2]
        settings.recentFile3 = files[3]
        Console.debug("cleanHistory: took " + (Date.now() - t) + "ms")
    }
}
