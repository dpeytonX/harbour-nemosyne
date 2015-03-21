/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.SailfishWidgets.JS 1.3
import harbour.nemosyne.Nemosyne 1.0

StandardCover {
    property variant pageStack
    property bool dbActive: ["question", "answer", "search"].indexOf(pageStack.currentPage.objectName) != -1

    id: cp
    coverTitle: UIConstants.appTitle
    imageSource: UIConstants.appIcon
    displayDefault: !(!!pageStack.currentPage && dbActive && !!cardDisplay.text)

    Subtext {
        anchors.top: label.bottom
        anchors.topMargin: Theme.paddingSmall
        anchors.horizontalCenter: parent.horizontalCenter
        text: dbActive ? qsTr("No Cards") : qsTr("no database")
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
        enabled: !displayDefault

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

    function isQuestion(page) {
        return page.objectName == "question";
    }

    function isAnswer(page) {
        return page.objectName == "answer";
    }

    function updateText() {
        if(!!pageStack.currentPage) {
            if(isQuestion(pageStack.currentPage)) cardDisplay.text = pageStack.currentPage.question
            else if(isAnswer(pageStack.currentPage)) cardDisplay.text = pageStack.currentPage.answer
        }
    }
}


