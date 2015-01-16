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
    }

    Binding { target: settings; property: "defaultFontSizeId"; value: fontCombo.currentIndex }

    FontHandler {
        id: fh
        Component.onCompleted: {
            Console.log(fontSizes)
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
    }
}
