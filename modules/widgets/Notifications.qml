import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.Notifications

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

    // Actually silence notifs, and detect that instead of setting this directly.
    property bool silenced: false
    function getBellIcon() {
        if (silenced) return Theme.icons.notifs.bellOff;
        if (NotificationService.historyModel.count > 0) return Theme.icons.notifs.bellBadge;
        if (!silenced) return Theme.icons.notifs.bell;
    }
    property string bellIcon: getBellIcon()
    Text {
        id: text
        text: root.bellIcon
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
                if (notifPanel.height == 0) {
                    notifPanel.height = Theme.notifPanel.height
                } else {
                    notifPanel.height = 0
                }
            } else if (mouse.button == Qt.RightButton) {
                // Actually silence notifications.
                // The icon get function will check if notifications are silenced or not.
                root.silenced = !root.silenced
            }
        }
    }

    PanelWindow {
        id: notifContainer
        visible: notifPanel.height == 0 ? false : true
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        color: "transparent"
        BackgroundEffect.blurRegion: Region { item: notifPanel; radius: Theme.radius }

        anchors {
            left: true
            bottom: true
            top: true
            right: true
        }
        margins {
            top: Theme.notifPanel.margins
            left: Theme.notifPanel.margins
        }

        // Makes a region mask so only the specified region in the PanelWindow
        // can be interacted with. `item` here sets the region to a specific item.
        // In this case, the below `Rectangle`.
        mask: Region {
            item: notifPanel
        }
        Rectangle {
            id: notifPanel

            focus: true
            Keys.onEscapePressed: {
                height = 0
            }

            width: Theme.notifPanel.width
            Behavior on height {
                NumberAnimation {
                    easing.type: Easing.InOutQuad
                }
            }

            radius: Theme.radius
            border {
                color: Theme.border.color
                width: Theme.border.width
            }
            color: Theme.notifPanel.bgColor

            Rectangle {
                id: clearButton

                color: Theme.bgColor
                radius: Theme.radius
                bottomLeftRadius: 0
                bottomRightRadius: 0
                border {
                    color: Theme.border.color
                    width: Theme.border.width
                }
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: 40

                Text {
                    text: Theme.icons.notifs.clear
                    color: Theme.textColor
                    font {
                        family: Theme.font.family
                        pixelSize: Theme.font.size
                    }
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill: parent;
                    cursorShape: Qt.PointingHandCursor;
                    acceptedButtons: Qt.LeftButton;
                    onClicked: NotificationService.historyModel.clear();
                }
            }

            ListView {
                id: listView

                clip: true
                anchors {
                    top: clearButton.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                topMargin: Theme.notifPanel.padding
                bottomMargin: Theme.notifPanel.padding
                spacing: Theme.notifPanel.spacing

                model: NotificationService.historyModel

                delegate: ClippingRectangle {
                    width: listView.width - Theme.notifPanel.padding * 2
                    height: Theme.notifs.height
                    anchors.horizontalCenter: parent?.horizontalCenter

                    function getColor() {
                        switch (urgency) {
                            case 0: return Theme.notifs.borderUrgency.low;
                            case 1: return Theme.notifs.borderUrgency.normal;
                            case 2: return Theme.notifs.borderUrgency.critical;
                        }
                    }
                    color: Theme.bgColor
                    radius: Theme.radius
                    border {
                        color: getColor()
                        width: Theme.border.width
                    }


                    Image {
                        // I need to cache the image in NotificationService so it can
                        // show an image even if Notification server is no longer providing it.
                        source: image
                        width: Theme.notifs.imageWidth
                        fillMode: Image.PreserveAspectFit
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: Theme.notifs.padding
                        }
                    }
                    Text {
                        text: time // Gets updated to current time when bar restarts...
                        color: "white"
                        font {
                            family: Theme.font.family
                            pixelSize: Theme.font.size
                        }
                        anchors {
                            right: parent.right
                            top: parent.top
                            rightMargin: Theme.notifs.padding
                            topMargin: Theme.notifs.padding
                        }
                    }
                    Column {
                        width: image ? parent.width - (Theme.notifs.imageWidth + Theme.notifs.padding * 2) : parent.width
                        anchors {
                            left: parent.left
                        }
                        topPadding: Theme.notifs.padding
                        leftPadding: image ? Theme.notifs.imageWidth + Theme.notifs.padding * 2 : Theme.notifs.padding

                        Text {
                            text: appName
                            color: Theme.notifs.textColor.appName
                            width: parent.width
                            wrapMode: Text.Wrap
                            font {
                                family: Theme.font.family
                                pixelSize: Theme.font.size
                                bold: true
                            }
                        }
                        Text {
                            text: summary + " >"
                            color: Theme.notifs.textColor.summary
                            width: parent.width
                            wrapMode: Text.Wrap
                            font {
                                family: Theme.font.family
                                pixelSize: Theme.font.size
                                bold: true
                            }
                        }
                        Text {
                            text: body
                            color: Theme.notifs.textColor.body
                            width: parent.width
                            wrapMode: Text.Wrap
                            font {
                                family: Theme.font.family
                                pixelSize: Theme.font.size
                            }
                        }
                    }

                    function handleClick() {
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor;
                        acceptedButtons: Qt.LeftButton;
                        onClicked: NotificationService.historyModel.remove(index);
                    }
                }

            }
        }
    }
}
