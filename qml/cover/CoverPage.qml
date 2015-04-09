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
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.SailfishWidgets.JS 1.3
import harbour.nemosyne.Nemosyne 1.0

StandardCover {
    property variant pageStack
    property bool dbActive: !!pageStack.currentPage && !isMain(pageStack.currentPage)
    property int appState: !!Qt.application.state ? Qt.application.state :
                                                    (Qt.application.active ? 1 : 0) //VM compat

    id: cp
    coverTitle: UIConstants.appTitle
    imageSource: UIConstants.appIcon
    displayDefault: !(!!pageStack.currentPage && dbActive && !!cardDisplay.text)

    Subtext {
        id: smallText
        anchors.top: label.bottom
        anchors.topMargin: Theme.paddingSmall
        anchors.horizontalCenter: parent.horizontalCenter
        text: updateSmallText()
        visible: displayDefault
    }

    Column {
        anchors.fill: parent
        Paragraph {
            color: Theme.primaryColor
            id: cardDisplay
            width: parent.width
            visible: !displayDefault
        }
    }

    CoverActionList {
        enabled: !displayDefault && !isSearch(pageStack.currentPage)

        CoverAction {
            iconSource: IconThemes.iconCoverPrevious
            onTriggered: {
                if(isAnswer(pageStack.currentPage)) {
                    cardDisplay.text = " "
                    pageStack.pop();
                }
            }
        }

        CoverAction {
            iconSource: IconThemes.iconCoverNext
            onTriggered: {
                if(isQuestion(pageStack.currentPage)) {
                    cardDisplay.text = " "
                    pageStack.currentPage.accept()
                }
            }
        }
    }

    onPageStackChanged: {
        if(!!pageStack) {
            pageStack.currentPageChanged.connect(updateText)
        }
    }

    onAppStateChanged: {
        if((!!Qt.ApplicationActive && appState != Qt.ApplicationActive) || appState === 0)
            updateText()
    }

    function isQuestion(page) {
        return !!page && page.objectName == "question";
    }

    function isAnswer(page) {
        return !!page && page.objectName == "answer";
    }

    function isSearch(page) {
        return !!page && page.objectName == "search";
    }

    function isMain(page) {
        return !!page && page.objectName == "main";
    }

    function updateText() {
        var curPage = pageStack.currentPage
        if(curPage == null) return

        console.log("updateText: objectName: " + curPage.objectName)
        if(isQuestion(curPage)) cardDisplay.text = curPage.question
        else if(isAnswer(curPage)) cardDisplay.text = curPage.answer
        else if(isSearch(curPage)) {
            console.log("updateText: showing " + curPage.count + " results")
            if(curPage.count > 0)
                cardDisplay.text = curPage.results.join("\n")
            else
                cardDisplay.text = ""
        }
        else cardDisplay.text = ""
    }

    function updateSmallText() {
        if(!!pageStack.currentPage && isSearch(pageStack.currentPage)) {
            return qsTr("No search results")
        }
        if(dbActive) {
            if(isQuestion(pageStack.currentPage) || isAnswer(pageStack.currentPage))
                return qsTr("No Cards") // question or answer page with no text
            else
                return ""
        }
        return qsTr("no database") //main page
    }
}


