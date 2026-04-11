import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

import "../utils/"


Rectangle {
    id: root
    property bool activeOutput: true
    visible: activeOutput

    height: Theme.bar.height
    implicitWidth: iconDisplay.width + Theme.bar.padding * 2

    color: Theme.bgColor
    radius: Theme.radius
    border {
        color: Theme.border.color
        width: Theme.border.width
    }

    property string icon: Theme.icons.sysTray.closed
    Text {
        id: iconDisplay
        text: root.icon
        color: Theme.textColor
        font {
            family: Theme.font.family
            pixelSize: Theme.font.size
        }
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor;
        acceptedButtons: Qt.LeftButton
        onClicked: (mouse)=> {
            if (root.icon == Theme.icons.sysTray.closed) {
                root.icon = Theme.icons.sysTray.opened
            } else {
                root.icon = Theme.icons.sysTray.closed
            }
        }
    }
}
