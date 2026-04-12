pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications


Singleton {
    id: root
    property var notifications: server ? server.trackedNotifications : []
    readonly property bool hasNotifications: server.trackedNotifications.values.length > 0

    Connections {
        target: server
        function onNotification(n) {
            if (!n.transient) {
                n.tracked = true
            }
        }
    }

    NotificationServer {
        id: server
    }
}
