import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.nemosyne.QmlLogger 2.0
import harbour.nemosyne.Nemosyne 1.0
import harbour.nemosyne.SailfishWidgets.Components 1.3
import harbour.nemosyne.SailfishWidgets.Settings 1.3

Page {
    id: settingsPage

    ApplicationSettings {
        id: settings
        applicationName: "harbour-nemosyne"
        fileName: "settings"

        property int defaultFontSizeId: 0
        property bool slideRatings: false
        property int resetHour: 0
        property int resetMinute: 0
        property string timeText: "00:00"
    }

    Binding { target: settings; property: "defaultFontSizeId"; value: fontCombo.currentIndex }
    Binding { target: settings; property: "slideRatings"; value: useSliders.checked }

    FontHandler {
        id: fh
        Component.onCompleted: {
            Console.log(fontSizes)
        }
    }

    Component {
        id: timePicker
        TimePickerDialog {
            property int h: settings.resetHour

            hour: hourMode === DateTime.TwelveHours ? (h == 12 ? 12 : h % 12) : h
            minute: settings.resetMinute

            onAccepted: {
                settings.resetHour = hour
                settings.resetMinute = minute
                settings.timeText = timeText
            }
        }
    }

    PageColumn {
        title: qsTr("Settings")

        ComboBox {
            id: fontCombo
            label: qsTr("Font Size")
            width: settingsPage.width

            currentIndex: settings.defaultFontSizeId

            menu: ContextMenu {
                Repeater {
                    model: fh.fontIndices
                    StandardMenuItem { text: fh.fontSizes[index] }
                }
            }
        }

        TextSwitch {
            id: useSliders
            description: qsTr("Rate cards by indicators instead of push-up menu")
            text: qsTr("Use Indicators")
            checked: settings.slideRatings
        }

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
}
