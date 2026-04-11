import QtQuick
import Quickshell
import Niri 0.1
import Quickshell.Wayland
import "../utils/"


Rectangle {
    id: root
    required property int maxWidth
    property bool activeOutput: true

    Niri {
        id: niri
        Component.onCompleted: connect()

        onConnected: console.log("Connected to niri")
        onErrorOccurred: function(error) {
            console.error("Error:", error)
        }
    }

    function getVisibility() {
        if (niri.focusedWindow && activeOutput) {
            return true
        }
        return false
    }
    visible: getVisibility()

    function getWidth(max) {
        let charWidth = title.width/title.text.length
        let maxWidth = charWidth * max + charWidth * 3 + Theme.bar.padding * 2
        return Math.min(title.width + Theme.bar.padding * 2, maxWidth)
    }

    height: Theme.bar.height
    implicitWidth: getWidth(maxWidth)

    color: Theme.bgColor
    radius: Theme.radius
    border {
        color: Theme.border.color
        width: Theme.border.width
    }

    Text {
        id: title
        text: niri.focusedWindow?.title.length > maxWidth ? niri.focusedWindow?.title.substring(0, maxWidth) + '...' : niri.focusedWindow?.title
        color: Theme.textColor
        font {
            family: Theme.font.family
            pixelSize: Theme.font.size
        }
        anchors.centerIn: parent
    }
}
