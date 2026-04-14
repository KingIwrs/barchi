pragma Singleton
import QtQuick

QtObject {
    id: root

    readonly property var bar: QtObject {
        readonly property int height: 35
        readonly property var margin: QtObject {
            readonly property int top: 6
            readonly property int left: 12
            readonly property int right: 12
        }
        readonly property int padding: 12
        readonly property int spacing: 8
    }

    readonly property var notifPanel: QtObject {
        readonly property color bgColor: "#99000000"
        readonly property int width: 440
        readonly property int height: 500
        readonly property int margins: 12
        readonly property int padding: 24
        readonly property int spacing: 12
    }
    readonly property var notifs: QtObject {
        readonly property int maxPopups: 5
        readonly property int maxHistory: 100
        readonly property int height: 120
        readonly property int imageWidth: 75
        readonly property var borderUrgency: QtObject {
            readonly property color low: "#004466"
            readonly property color normal: "#7bccff"
            readonly property color critical: "#990000"
        }
        readonly property int padding: 12
        readonly property var textColor: QtObject {
            readonly property color appName: "yellow"
            readonly property color summary: "white"
            readonly property color body: "#cccccc"
        }
        readonly property var expireTime: QtObject {
            readonly property bool keepOriginal: true
            readonly property real lowUrgency: 3000
            readonly property real normalUrgency: 5000
            readonly property real criticalUrgency: 0 // 0 == don't expire
        }
    }

    readonly property int radius: 20
    readonly property color bgColor: "#55000000"
    readonly property var border: QtObject {
        readonly property color color: "#ff7bccff"
        readonly property int width: 3
    }

    readonly property color textColor: "#f0f0f0"
    readonly property var font: QtObject {
        readonly property string family: "Sono"
        readonly property int size: 14
    }

    readonly property var icons: QtObject {
        readonly property var battery: QtObject {
            readonly property string lvl0: "\uf244 "
            readonly property string lvl1: "\uf243 "
            readonly property string lvl2: "\uf242 "
            readonly property string lvl3: "\uf241 "
            readonly property string lvl4: "\uf240 "
            readonly property string charging: "\udb85\udc0b "
        }

        readonly property var sysTray: QtObject {
            readonly property string closed: "\uf107"
            readonly property string opened: "\uf068"
        }

        readonly property var notifs: QtObject {
            readonly property string bell: "\udb80\udc9a"
            readonly property string bellBadge: "\udb84\udd6b"
            readonly property string bellOff: "\udb80\udc9b"
            readonly property string clear: "\udb80\udf9f"
        }

        readonly property var volume: QtObject {
            readonly property string high: "\uf028"
            readonly property string medium: "\uf027"
            readonly property string low: "\uf026"
            readonly property string off: "\ueee8"
        }

        readonly property var bluetooth: QtObject {
            readonly property string on: "\udb80\udcaf"
            readonly property string off: "\udb80\udcb2"
        }

        readonly property var net: QtObject {
            readonly property string ethernet: "\udb80\ude00"
            readonly property string off: "\udb80\ude02"
            readonly property string wifi: "\uf1eb"
        }
    }

    readonly property var exec: QtObject {
        readonly property string audio: "/usr/bin/wezterm -e wiremix"
        readonly property string bluetooth: "/usr/bin/wezterm -e bluetui"
        readonly property string net: "/usr/bin/wezterm -e impala"
    }
}
