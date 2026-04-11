import QtQuick
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

    Text {
        id: text
        property string mode: "time"
        text: mode == "time" ? Time.time : Time.datetime
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
                if (text.mode == "time") {
                    text.mode = "datetime"
                } else if (text.mode == "datetime") {
                    text.mode = "time"
                }
            } else if (mouse.button == Qt.RightButton) {
                // Popup widget that shows time in hh.mm.ss format, and has a simple calender.
            }
        }
    }
}
