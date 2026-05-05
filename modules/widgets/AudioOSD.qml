import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire

import "../utils/"

// Mostly copied from: https://git.outfoxxed.me/quickshell/quickshell-examples/src/branch/master/volume-osd/shell.qml

Item {
    id: root
    property bool activeOutput: true
    visible: activeOutput

	// Bind the pipewire node so its volume will be tracked
	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

	Connections {
		target: Pipewire.defaultAudioSink?.audio

		function onVolumeChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}
	}

	property bool shouldShowOsd: false

	Timer {
		id: hideTimer
		interval: 1000
		onTriggered: root.shouldShowOsd = false
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

	// The OSD window will be created and destroyed based on shouldShowOsd.
	// PanelWindow.visible could be set instead of using a loader, but using
	// a loader will reduce the memory overhead when the window isn't open.
	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {
			// Since the panel's screen is unset, it will be picked by the compositor
			// when the window is created. Most compositors pick the current active monitor.

            Component.onCompleted: {
                if (this.WlrLayershell != null) {
                    this.WlrLayershell.layer = WlrLayer.Overlay;
                }
            }

            anchors {
                top: true
                right: true
            }
            margins {
                top: 25
                right: 25
            }
			exclusiveZone: 0

			implicitWidth: 350
			implicitHeight: 50
			color: "transparent"

			// An empty click mask prevents the window from blocking mouse events.
			mask: Region {}

			Rectangle {
				anchors.fill: parent
				radius: Theme.radius
				color: "#99000000"
                border {
                    color: Theme.border.color
                    width: Theme.border.width

                }

				RowLayout {
					anchors {
						fill: parent
						leftMargin: 10
						rightMargin: 15
					}

                    Text {
                        text: root.volumeIcon + " " + root.volumeText
                        color: "white"
                    }

					Rectangle {
						// Stretches to fill all left-over space
						Layout.fillWidth: true

						implicitHeight: 10
						radius: Theme.radius
						color: "#50ffffff"

						Rectangle {
							anchors {
								left: parent.left
								top: parent.top
								bottom: parent.bottom
							}

							implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
							radius: Theme.radius
						}
					}
				}
			}
		}
	}
}
