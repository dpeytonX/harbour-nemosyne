/*
........
TaskList - A small but mighty program to manage your daily tasks.
Copyright (C) 2014 Thomas Amler
Contact: Thomas Amler <armadillo@penguinfriends.org>
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
.........
** Modified portions of this file are part of SailfishWidgets
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
*/
import QtQuick 2.1
import Sailfish.Silica 1.0

/*!
   \qmltype AboutPage
   \since 5.1
   \brief Displays a summary page for your application
   \inqmlmodule SailfishWidgets.Components

   Back to \l {Sailfish Widgets}

  \image about_page.png "Example About Page"

  Displays a page that summarizes your application. It includes places for your open source project links, copyright information, application data, and so on. Push this onto the \c pageStack as you would any other page.

  A special note:
  I was given permission to incorporate this into \l {Sailfish Widgets} by Thomas Amler.

  \l {https://github.com/Armadill0/harbour-tasklist}{Tasklist}

  */
OrientationPage {
    /*!
       \qmlproperty alias AboutPage::aboutTaskList
      An alias to the \c SilicaFlickable page container
    */
    property alias aboutContent: aboutTaskList
    /*!
       \qmlproperty alias AboutPage::pageTitle
      Use this to set the page's title.
    */
    property alias pageTitle: headline.title
    /*!
       \qmlproperty alias AboutPage::headline
      An alias to the \c PageHeader Component
    */
    property alias headline: headline
    /*!
       \qmlproperty alias AboutPage::description
      A string describing the purpose of the application.
    */
    property string description
    /*!
       \qmlproperty alias AboutPage::icon
      A string representing the location of the application's icon. It can be a resource URI.
    */
    property string icon
    /*!
       \qmlproperty alias AboutPage::application
      A string with the application's name
    */
    property string application
    /*!
       \qmlproperty alias AboutPage::copyrightHolder
      A string representing the individual or organization holding the application's copyright.
    */
    property string copyrightHolder
    /*!
       \qmlproperty alias AboutPage::copyrightYear
      A string holding the year(s) that the copyright was instituted.
    */
    property string copyrightYear
    /*!
       \qmlproperty alias AboutPage::contributors
      A string array of the contributors to this application.
    */
    property variant contributors
    /*!
       \qmlproperty alias AboutPage::licenses
      A string array of licenses in effect for this application.
    */
    property variant licenses
    /*!
       \qmlproperty alias AboutPage::projectLinks
      A string list of URLs for more information about the application.
    */
    property variant projectLinks

    id: aboutPage

    SilicaFlickable {
        id: aboutTaskList
        anchors.fill: parent
        contentHeight: aboutRectangle.height
        VerticalScrollDecorator { flickable: aboutTaskList }

        Column {
            id: aboutRectangle
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader {id: headline }

            Image {
                source: icon
                width: parent.width
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
            }

            Label {
                text: application
                horizontalAlignment: Text.Center
                width: parent.width - Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }

            SectionHeader {
                //: headline for application description
                text: qsTr("Description")
            }

            Label {
                //: TaskList description
                text: description
                width: parent.width - Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
            }
            SectionHeader {
                //: headline for application licensing information
                text: qsTr("Licensing")
            }
            Label {
                //: Copyright and license information
                text: qsTr("Copyright © ") + (!!copyrightYear ? copyrightYear : "") + " "
                      + (!!copyrightHolder ? copyrightHolder : application)
                width: parent.width - Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeSmall
            }

            Label {
                //: Copyright and license information
                text: qsTr("License") + ": " + (!!licenses ? licenses.toString() : qsTr("Unspecified"))
                width: parent.width - Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeSmall
            }

            SectionHeader {
                //: headline for application project information
                text: qsTr("Project information")
                font.pixelSize: Theme.fontSizeSmall
            }
            Label {
                textFormat: Text.RichText
                text: !!projectLinks ? "<style>a:link { color: " + Theme.highlightColor + "; }</style>" + generateProjectInfo()
                                     : qsTr("None")

                width: parent.width - Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeSmall
                truncationMode: TruncationMode.Fade
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }

                function generateProjectInfo() {
                    var projInfo = ""
                    for(var i in projectLinks) {
                       var link = "<a href=\"" + projectLinks[i] + "\">" + projectLinks[i] + "</a><br/>";
                       projInfo += link
                    }
                    return projInfo;
                }
            }
            SectionHeader {
                //: headline for application contributors
                text: qsTr("Contributors")
            }
            Repeater {
                model: contributors
                delegate: Label {
                    text: "- " + modelData
                    width: parent.width - Theme.paddingLarge * 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeSmall
                }
            }
            Rectangle {
                width: parent.width
                height: Theme.paddingLarge
                color: "transparent"
            }
        }
    }
}
