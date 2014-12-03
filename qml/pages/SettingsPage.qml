import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.nemosyne.SailfishWidgets.Settings 1.2

Page {
    ApplicationSettings {
        property bool autoSave: true
        property bool autoSaveWhenDone: true
        property bool autoOpenDb: true
        property int  autoSaveAfterCard: 10

        applicationName: "harbour-nemosyne"
        fileName: "settings"
    }

    //TODO: show controls
}
