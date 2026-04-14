pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

import "../utils/"

// Noctalias code has been a big help to look through.

Singleton {
    id: root
    readonly property bool hasNotifications: server.trackedNotifications.values.length > 0
    property int maxPopups: Theme.notifs.maxPopups
    property int maxHistory: Theme.notifs.maxHistory

    property var popupModel: server ? server.trackedNotifications.values.slice(0, maxPopups) : []
    property ListModel historyModel: ListModel {}

    readonly property var popups: QtObject {
        readonly property bool isOverflow: server.trackedNotifications.values.length > maxPopups
        readonly property int overflowCount: server.trackedNotifications.values.length - maxPopups
    }

    Connections {
        target: server
        function onNotification(notif) {
            const time = new Date();
            notif.time = `${time.getHours()}.${time.getMinutes()}`
            notif.tracked = true;

            if (!notif.transient) {
                historyModel.insert(0, notif);
            }
            while (historyModel.count > maxHistory) {
                historyModel.remove(historyModel.count - 1);
            }
        }
    }

    NotificationServer {
        id: server
        imageSupported: true
        actionsSupported: true
    }
}
