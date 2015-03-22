import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.SailfishWidgets.JS 1.3
import harbour.nemosyne.Nemosyne 1.0

StandardCover {
    property variant pageStack
    property bool dbActive: ["question", "answer", "search"].indexOf(pageStack.currentPage.objectName) != -1
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

    function updateText() {
        var curPage = pageStack.currentPage
        if(curPage == null) return

        console.log("updateText: objectName: " + curPage.objectName)
        if(isQuestion(curPage)) cardDisplay.text = curPage.question
        else if(isAnswer(curPage)) cardDisplay.text = curPage.answer
        else if(isSearch(curPage)) {
            if(curPage.count > 0)
                cardDisplay.text = curPage.results.slice(0, 5).join("\n")
            else
                cardDisplay.text = ""
        }
    }

    function updateSmallText() {
        if(!!pageStack.currentPage && isSearch(pageStack.currentPage)) {
            return qsTr("No search results")
        }
        return dbActive ? qsTr("No Cards") : qsTr("no database")
    }
}


