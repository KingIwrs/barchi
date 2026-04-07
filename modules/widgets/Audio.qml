import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Io

import "../utils/"


Rectangle {
	id: root
    property bool activeOutput: true
    visible: activeOutput

	// Bind the pipewire node so its volume will be tracked
	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

    height: Theme.height
    implicitWidth: barText.width + 24
    color: Theme.bgColor
    radius: Theme.radius
    border {
        color: Theme.border.color
        width: Theme.border.width
    }

    function getIcon(v, muted) {
        if (v <= 0 || muted) return Theme.icons.volume.off;
        if (v < 0.15) return Theme.icons.volume.low;
        if (v < 0.4) return Theme.icons.volume.medium;
        return Theme.icons.volume.high;
    }
    function getText(v, muted) {
        if (muted) return "muted";
        return Math.round(v * 100) + "%";
    }

    property string volumeIcon: getIcon(Pipewire.defaultAudioSink?.audio.volume, Pipewire.defaultAudioSink?.audio.muted)
    property string volumeText: getText(Pipewire.defaultAudioSink?.audio.volume, Pipewire.defaultAudioSink?.audio.muted)

    Text {
        id: barText
        text: root.volumeIcon + " " + root.volumeText
        color: Theme.textColor
        font {
            family: Theme.font.family
            pixelSize: Theme.font.size
        }
        anchors.centerIn: parent
    }

    Process {
        id: openWiremix
        command: [ "wezterm-gui", "-e", Theme.apps.audio ]
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor;
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.Wheel
        onClicked: (mouse)=> {
            if (mouse.button == Qt.LeftButton) {
                Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
            } else if (mouse.button == Qt.RightButton) {
                openWiremix.startDetached()
            }
        }
        onWheel: (mouse)=> {
            print(mouse?.angleDelta.y) // down is negative. up is positive.
            let volumeModifier = mouse.angleDelta.y / Math.abs(mouse.angleDelta.y)
            Pipewire.defaultAudioSink.audio.volume = Pipewire.defaultAudioSink.audio.volume + volumeModifier * 0.02
        }
    }
}
