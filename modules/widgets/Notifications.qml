import QtQuick
import Quickshell
import Quickshell.Services.Notifications

import "../utils/"


Rectangle {
    id: root
    property bool activeOutput: true
    visible: activeOutput

    height: Theme.height
    implicitWidth: text.width + Theme.padding * 2

    color: Theme.bgColor
    radius: Theme.radius
    border {
        color: Theme.border.color
        width: Theme.border.width
    }

    property bool silenced: false
    function getBellIcon() {
        if (silenced) return Theme.icons.notifications.bellOff;
        // Detect if there is any notifications and show
        // Theme.icons.notifications.bellBadge instead.
        if (!silenced) return Theme.icons.notifications.bell;
    }
    property string bellIcon: getBellIcon()
    Text {
        id: text
        text: root.bellIcon
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
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse)=> {
            if (mouse.button == Qt.LeftButton) {
                console.log("Notification: Left click")
                // Open a notification tray.
            } else if (mouse.button == Qt.RightButton) {
                // Silence notifications. Set "root.silenced" to the state of actual notifications instead using hopes and dreams here.
                root.silenced = !root.silenced
            }
        }
    }
}
