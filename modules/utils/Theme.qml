pragma Singleton
import QtQuick

QtObject {
    id: root

    readonly property int height: 35
    readonly property int radius: 20
    readonly property int marginTop: 6
    readonly property int marginLeft: 12
    readonly property int marginRight: 12
    readonly property int padding: 12
    readonly property int spacing: 8
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
        readonly property string sysTrayClosed: "\uf107"
        readonly property string sysTrayOpened: "\uf068"
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
    readonly property var apps: QtObject {
        readonly property string audio: "wiremix"
        readonly property string bluetooth: "bluetui"
        readonly property string net: "impala"
    }
}
