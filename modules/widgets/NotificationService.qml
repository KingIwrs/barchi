pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications


Singleton {
    id: root
    property var notifications: server ? server.trackedNotifications : []

    Connections {
        target: server
        function onNotification(n) {
            n.tracked = true
        }
    }

    NotificationServer {
        id: server
    }
}
