pragma Singleton

import QtQuick
import Quickshell


Singleton {
    id: root

    readonly property string datetime: {
        Qt.formatDateTime(clock.date, "yyyy-MM-dd ddd hh.mm")
    }
    readonly property string time: {
        Qt.formatDateTime(clock.date, "hh.mm")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
