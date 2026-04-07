import QtQuick
import Quickshell.Io
import Quickshell.Bluetooth
import Quickshell.Networking
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

    function getBluetoothState() {
        if (Bluetooth.defaultAdapter.state == 1) { // 1 == "Enabled"
            return Theme.icons.bluetooth.on
        } else if (Bluetooth.defaultAdapter.state == 0) { // 2 == "Disabled"
            return Theme.icons.bluetooth.off
        }
    }

    property string ethernetState
    Process {
        id: getEthernetState
        command: [ "sh", "-c", "nmcli device | grep \"ethernet.*connected\"" ]
        stdout: StdioCollector {
            onStreamFinished: ethernetState = this.text
        }
    }
    function getNetworkState() {
        getEthernetState.running = true
        let icon = Theme.icons.net.off
        if (ethernetState != "") {
            icon = Theme.icons.net.ethernet
        } else {
            if (Networking.wifiEnabled) {
                icon = Theme.icons.net.wifi
            }
        }
        return icon
    }

    property string bluetoothState: getBluetoothState()
    property string netState: getNetworkState()

    property string buttonText: this.bluetoothState + "  |  " + this.netState

    Text {
        id: text
        anchors.centerIn: parent
        text: root.buttonText
        font.pixelSize: Theme.font.size
        color: Theme.textColor
    }

    Process {
        id: openBluetui
        command: [ "wezterm-gui", "-e", Theme.apps.bluetooth ]
    }
    MouseArea {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 2
        cursorShape: Qt.PointingHandCursor;
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse)=> {
            if (mouse.button == Qt.LeftButton) {
                Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
            } else if (mouse.button == Qt.RightButton) {
                openBluetui.startDetached()
            }
        }
    }
    Process {
        id: openImpala
        command: [ "wezterm-gui", "-e", Theme.apps.net ]
    }
    MouseArea {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 2
        cursorShape: Qt.PointingHandCursor;
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse)=> {
            if (mouse.button == Qt.LeftButton) {
                Networking.wifiEnabled = !Networking.wifiEnabled
            } else if (mouse.button == Qt.RightButton) {
                openImpala.startDetached()
            }
        }
    }
}
