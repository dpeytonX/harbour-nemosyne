/***************************************************************************
** This file is part of SailfishWidgets
**
** Copyright (c) 2014 Dametrious Peyton
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

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Components" 1.2
import "../JS" 1.2
import "." 1.2

/*!
   \qmltype FileSelector
   \since 5.0
   \brief Allows files to be selected from the filesystem.
   \inqmlmodule SailfishWidgets.FileManagement

   Back to \l {Sailfish Widgets}

  Displays a file system browser that allows a user to select one or more files
  or directories that are stored in a \c ListView
 
  \image file_selector.png "File Selector in action"
  It uses the \l {Dir} Qt object which provides the directory list
  and exposes some methods from \c {QDir} as Qml Properties

  This widget inherits the properties and signals from Sailfish.Silica Dialog.

   \code
  Qml                           Instantiates
  This dialog -------------> Qml DirectoryInfo (handles all operations)
                                Sends back
  dynamically <-------------- list of QFiles matching request
  populates list view
  \endcode
  */

Dialog {
    /*!
       \qmlproperty alias FileSelector::fileList
      An alias to the \l {Dir} object.
    */
    property alias directory: fileList
    /*!
       \qmlproperty alias FileSelector::filter
       An enum type that controls what file system types to display in the \c ListView.
       Uses the \l {Dir} \c DirFilter enum. You can chain enums using bitwise-or \c |.
       Its syntax follows that same as that of \c QDir::entryList.
    */
    property alias filter: fileList.filter
    /*!
       \qmlproperty alias FileSelector::header
       An alias to the \c listView object's \c DialogHeader
    */
    property alias header: listView.header
    /*!
       \qmlproperty alias FileSelector::sort
       An enum type that controls the order of file system types to display in the \c ListView.
       Uses the \l {Dir} \c DirSort enum. You can chain enums using bitwise-or \c |.
       Its syntax follows that same as that of \c QDir::entryList.
    */
    property alias sort: fileList.sort
    /*!
       \qmlproperty alias FileSelector::multiSelect
       Set this to \c true to allow users to select more than one file. \c false by default.
    */
    property bool multiSelect: false
    /*!
       \qmlproperty alias FileSelector::quickSelect
       Set this to \c false to force users to use the \c ListItem \c ContextMenu in order
       to select files. \c true by default to allow single type selection of files.
       Directories always require \c ContextMenu select.
    */
    property bool quickSelect: true
    /*!
       \qmlproperty alias FileSelector::selectionFilter
      An alias to an enum type that controls which elements can be selected. It uses the same
      enum as \l {Dir} \c DirFilter.
    */
    property int selectionFilter: Dir.AllEntries | Dir.Readable | Dir.Hidden
    /*!
       \qmlproperty alias FileSelector::acceptText
       Text that should be displayed in the Accept toolbar of this Dialog.
    */
    property string acceptText: directory.dirName
    /*!
       \qmlproperty alias FileSelector::baseDirectory
       Text property which is a file path that this Dialog should show at first.
       Defaults to \l {Dir} \c XdgHome
    */
    property string baseDirectory: fileList.XdgHome
    /*!
       \qmlproperty alias FileSelector::cancelText
       Text that should be displayed in the Cancel toolbar of this Dialog.
    */
    property string cancelText
    /*!
       \qmlproperty alias FileSelector::deselectText
       Text that should be displayed in the selection \c ContextMenu when deselecting a file.
    */
    property string deselectText
    /*!
       \qmlproperty alias FileSelector::headerTitle
       Displays "No items" when no items are present. Override to provide custom text.
    */
    property string headerTitle
    /*!
       \qmlproperty alias FileSelector::selectText
       Title text that should be displayed just above the \c {ListView} 
    */
    property string selectText
    /*!
       \qmlproperty alias FileSelector::selectedFiles
       Variant-list which holds the \c {Files} thata are selected.
    */
    property variant selectedFiles: []

    canAccept: !!selectedFiles && !!(selectedFiles.length)
    id: fileSelector

    StandardListView {
        anchors.fill: parent
        delegate: ListItem {
            property bool selected: false
            property File file: modelData

            id: contentItem
            menu: contextMenuComponent
            showMenuOnPressAndHold: matchSelectionFilter(file)

            Image {
                x: Theme.paddingSmall
                height: file.dir ? parent.height - Theme.paddingSmall : 0
                width: height
                id: icon
                source: file.dir ? IconThemes.iconDirectory : ""
            }

            InformationalLabel {
                anchors.left: icon.right
                anchors.leftMargin: Theme.paddingSmall
                anchors.verticalCenter: parent.verticalCenter
                color: selected ? Theme.primaryColor : (matchSelectionFilter(file) ? Theme.highlightColor : Theme.secondaryHighlightColor)
                text: file.fileName
            }

            onClicked: {
                if(file.dir) {
                    fileList.path = file.absoluteFilePath
                } else {
                    if(quickSelect) makeSelection(file)
                }
            }

            Component.onCompleted: listView.updateSelected()
        }
        header: DialogHeader {
            acceptText: fileSelector.acceptText
            cancelText: fileSelector.cancelText
            id: dialogHeader
            title: fileSelector.headerTitle
        }
        id: listView
        model: fileList.files


        Component {
            id:contextMenuComponent
            ContextMenu {
                id: context
                StandardMenuItem {
                    text: !!context.parent ? (context.parent.selected ? deselectText : selectText) : ""
                    onClicked: {
                        makeSelection(context.parent.file)
                    }
                }
            }
        }

        VerticalScrollDecorator {}

        function updateSelected() {
            for(var i = 0; i < listView.contentItem.children.length; i++) {
                var child = listView.contentItem.children[i]
                if(!!child.file)
                    child.selected = selectedFiles.indexOf(child.file) != -1
            }
        }
    }

    Dir {
        id: fileList
        filter: Dir.AllEntries | Dir.Hidden
        sort: Dir.DirsFirst | Dir.Name

        onPathChanged: {clearSelection(); refresh()}
    }

    onBaseDirectoryChanged: fileList.path = baseDirectory

    onRejected: clearSelection()

    /*!
      \internal
    */
    function clearSelection() {
        while(!!selectedFiles && selectedFiles.length) makeSelection(selectedFiles[0])
    }

    /*!
      \internal
    */
    function makeSelection(file) {
        if(selectedFiles.indexOf(file) != -1) {
            selectedFiles = Variant.remove(selectedFiles, file)
        } else {
            if(!matchSelectionFilter(file))
                return

            if(!multiSelect) selectedFiles = []
            selectedFiles = Variant.add(selectedFiles, file)
        }

        listView.updateSelected()
        canAccept = selectedFiles.length
    }

    /*!
      \internal
    */
    function matchSelectionFilter(file) {
        if((selectionFilter & Dir.Readable) && !file.readable) return false
        if((selectionFilter & Dir.Writable) && !file.writable) return false
        if((selectionFilter & Dir.Executable) && !file.executable) return false
        if((selectionFilter & Dir.NoSymLinks) && file.symLink) return false
        if(!(selectionFilter & Dir.Hidden) && file.hidden) return false

        //if(selectionFilter & Dir.AllEntries) return true
        if(selectionFilter & Dir.AllDirs & Dir.Files) return true
        if(selectionFilter & Dir.Dirs & Dir.Files) return true

        if((selectionFilter & Dir.Dirs) && !file.dir) return false
        if((selectionFilter & Dir.AllDirs) && !file.dir) return false
        if((selectionFilter & Dir.Files) && file.dir) return false
        return true
    }
}
