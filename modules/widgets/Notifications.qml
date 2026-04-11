import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

import "../utils/"


Rectangle {
    id: root
    property bool activeOutput: true
    visible: activeOutput

    height: Theme.bar.height
    implicitWidth: text.width + Theme.bar.padding * 2

    color: Theme.bgColor
    radius: Theme.radius
    border {
        color: Theme.border.color
        width: Theme.border.width
    }

    // Actually silence notifs, and detect that instead of setting this directly.
    property bool silenced: false
    function getBellIcon() {
        if (silenced) return Theme.icons.notifs.bellOff;
        // Detect if there is any notifications and show
        // Theme.icons.notifs.bellBadge instead.
        if (!silenced) return Theme.icons.notifs.bell;
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
                notifContainer.visible = !notifContainer.visible
            } else if (mouse.button == Qt.RightButton) {
                // Actually silence notifications.
                // The icon get function will check if notifications are silenced or not.
                root.silenced = !root.silenced
            }
        }
    }

    PanelWindow {
        id: notifContainer
        visible: false

        color: "transparent"
        BackgroundEffect.blurRegion: Region { item: notifPanel; radius: Theme.radius }
        anchors {
            left: true
            bottom: true
            top: true
            right: true
        }
        margins {
            top: Theme.notifPanel.margins
            left: Theme.notifPanel.margins
            right: Theme.notifPanel.margins
        }

        // Makes a region mask so only the specified region in the PanelWindow
        // can be interacted with. `item` here sets the region to a specific item.
        // In this case, the below `Rectangle`.
        mask: Region {
            item: notifPanel
        }
        Rectangle {
            id: notifPanel

            width: Theme.notifPanel.width
            height: Theme.notifPanel.height

            radius: Theme.radius
            border {
                color: Theme.border.color
                width: Theme.border.width
            }
            color: Theme.notifPanel.bgColor

            ListView {
                model: NotificationServer.trackedNotifications

                // Add the notifications here.
            }
        }
    }
}
