import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
  property alias text: lbl.text
  InformationalLabel {id: lbl; text: item.text}
}
