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
import harbour.nemosyne.QmlLogger 2.0
import harbour.nemosyne.Nemosyne 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.4
import harbour.nemosyne.SailfishWidgets.Settings 1.4
import harbour.nemosyne.SailfishWidgets.Language 1.4

Page {
    property variant fontSizes: [
        qsTr("Small"),
        qsTr("Medium"),
        qsTr("Large"),
        qsTr("Extra Large"),
        qsTr("Huge")
    ]
    allowedOrientations: Orientation.All
    id: settingsPage

    ApplicationSettings {
        id: settings
        applicationName: UIConstants.appName
        fileName: "settings"

        property int defaultFontSizeId: 0
        property bool slideRatings: false
        property bool autoOpenDb: false
        property int resetHour: 0
        property int resetMinute: 0
        property int hourMode: DateTime.DefaultHours
        property string timeText: "00:00"
        property string locale: ""
    }

    InstalledLocales {
        id: installedLocales
        includeAppDefault: true
        appName: UIConstants.appName
        applicationDefaultText: qsTr("Application Default");
    }

    Binding { target: settings; property: "defaultFontSizeId"; value: fontCombo.currentIndex }
    Binding { target: settings; property: "slideRatings"; value: useSliders.checked }
    Binding { target: settings; property: "autoOpenDb"; value: openDb.checked }

    FontHandler {
        id: fh
    }

    Component {
        id: timePicker
        TimePickerDialog {
            property int h: settings.resetHour

            hourMode: settings.hourMode
            hour: hourMode === DateTime.TwelveHours ? (h == 12 ? 12 : h % 12) : h
            minute: settings.resetMinute

            onAccepted: {
                settings.resetHour = hour
                settings.resetMinute = minute
                settings.timeText = timeText
                settings.hourMode = hourMode
            }
        }
    }

    PageHeader {
        id: header;
        title: qsTr("Settings")
    }

    SilicaFlickable {
        width: parent.width
        height: parent.height - header.height
        y: header.height

        contentHeight: Math.max(height - Theme.paddingLarge * 2, contentCol.childrenRect.height)

        Column {
            id: contentCol
            width: parent.width - Theme.paddingSmall - Theme.paddingLarge
            x: Theme.paddingLarge

            ComboBox {
                id: fontCombo
                label: qsTr("Font Size")
                width: settingsPage.width

                currentIndex: settings.defaultFontSizeId

                menu: ContextMenu {
                    Repeater {
                        model: fh.fontIndices
                        StandardMenuItem { text: fontSizes[index] }
                    }
                }
            }

            TextSwitch {
                id: useSliders
                description: qsTr("Rate cards by indicators instead of push-up menu")
                text: qsTr("Use Indicators")
                checked: settings.slideRatings
            }

            Row {
                spacing: Theme.paddingLarge
                width: parent.width

                InformationalLabel {
                    color: Theme.primaryColor
                    text: qsTr("Card Reset Time")
                }

                LabelButton {
                    id: button
                    text: settings.timeText

                    onClicked: {
                        pageStack.push(timePicker, {})
                    }
                }
            }

            TextSwitch {
                id: openDb
                description: qsTr("Automatically open the most recently database at launch")
                text: qsTr("Quick Launch")
                checked: settings.autoOpenDb
            }

            ComboBox {
                id: languageCombo
                description: qsTr("Switching languages requires an application restart")
                label: qsTr("Language")
                width: settingsPage.width

                currentIndex: installedLocales.findLocale(settings.locale) == -1 ?
                                  0 : installedLocales.findLocale(settings.locale)

                menu: ContextMenu {
                    Repeater {
                        model: installedLocales.locales
                        StandardMenuItem {
                            text: modelData.pretty
                            onClicked: settings.locale = modelData.locale
                        }
                    }
                }
            }
        }
        VerticalScrollDecorator {}
    }
}
