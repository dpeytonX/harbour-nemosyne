import QtQuick 2.1
import Sailfish.Silica 1.0

Item {

    property variant fontSizes: [
        qsTr("Small"),
        qsTr("Medium"),
        qsTr("Large"),
        qsTr("Extra Large"),
        qsTr("Huge")
    ]

    readonly property variant fontIndices: [
        Theme.fontSizeSmall,
        Theme.fontSizeMedium,
        Theme.fontSizeLarge,
        Theme.fontSizeExtraLarge,
        Theme.fontSizeHuge
    ]


}
