import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.Notifications

import "../utils/"


PanelWindow {
    id: root
    visible: NotificationService.hasNotifications ? true : false

    // // Uncomment if you can't press it.
    // WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.layer: WlrLayer.Overlay

    color: "transparent"

    anchors {
        left: true
        bottom: true
        top: true
        right: true
    }
    margins {
        top: Theme.notifPanel.margins
        right: Theme.notifPanel.margins
    }

    mask: Region {
        item: popNotifContainer
    }
    Rectangle {
        id: popNotifContainer

        color: "transparent"

        anchors {
            right: parent.right
        }
        height: listView.height
        width: Theme.notifPanel.width

        ListView {
            id: listView

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: contentHeight
            spacing: Theme.notifPanel.spacing
            verticalLayoutDirection: ListView.BottomToTop

            model: NotificationService.popupModel

            delegate: ClippingRectangle {
                width: listView.width
                height: Theme.notifs.height
                anchors.horizontalCenter: parent.horizontalCenter

                function getColor(modelData) {
                    switch (modelData.urgency) {
                        case 0: return Theme.notifs.borderUrgency.low;
                        case 1: return Theme.notifs.borderUrgency.normal;
                        case 2: return Theme.notifs.borderUrgency.critical;
                    }
                }
                color: Theme.bgColor
                radius: Theme.radius
                border {
                    color: getColor(modelData)
                    width: Theme.border.width
                }

                function getExpireTime(d) {
                    let expireTime = 0;
                    let keepOriginal = Theme.notifs.expireTime.keepOriginal
                    if (d.expireTimeout != -1 && keepOriginal) {
                        expireTime = d.expireTimeout
                    } else if (d.urgency == 0) {
                        expireTime = Theme.notifs.expireTime.lowUrgency;
                    } else if (d.urgency == 1) {
                        expireTime = Theme.notifs.expireTime.normalUrgency;
                    } else if (d.urgency == 2) {
                        expireTime = Theme.notifs.expireTime.criticalUrgency;
                    }

                    if (expireTime === 0) {
                        expireTimer.running = false;
                    }
                    return expireTime;
                }
                Timer {
                    id: expireTimer
                    interval: getExpireTime(modelData)
                    running: true
                    repeat: false
                    onTriggered: {
                        modelData.dismiss()
                    }
                }
                Image {
                    source: modelData.image
                    width: Theme.notifs.imageWidth
                    fillMode: Image.PreserveAspectFit
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: Theme.notifs.padding
                    }
                }
                Text {
                    text: modelData.time // Gets updated to current time when bar restarts...
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
                    width: modelData.image ? parent.width - (Theme.notifs.imageWidth + Theme.notifs.padding * 2) : parent.width
                    anchors {
                        left: parent.left
                    }
                    topPadding: Theme.notifs.padding
                    leftPadding: modelData.image ? Theme.notifs.imageWidth + Theme.notifs.padding * 2 : Theme.notifs.padding

                    Text {
                        text: modelData.appName
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
                        text: modelData.summary + " >"
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
                        text: modelData.body
                        color: Theme.notifs.textColor.body
                        width: parent.width
                        wrapMode: Text.Wrap
                        font {
                            family: Theme.font.family
                            pixelSize: Theme.font.size
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor;
                    acceptedButtons: Qt.LeftButton
                    onClicked: (mouse)=> {
                        if (mouse.button == Qt.LeftButton) {
                            for (let i = 0; i < modelData.actions.length; i++) {
                                if (modelData.actions[i].identifier == "default") {
                                    modelData.actions[i].invoke();
                                }
                            }
                            modelData.dismiss();
                        }
                    }
                }

                Row {
                    id: btnsRow
                    visible: modelData.actions[1] ? true : false

                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                    height: 30

                    Repeater {
                        id: actionBtnRepeater
                        function createActionsModel(actions) {
                            var list = [];
                            for (var i = 0; i < actions.length; i++) {
                                if (actions[i].identifier != "default") list.push(modelData.actions[i]);
                            }
                            return list
                        }
                        property var actionsModel: createActionsModel(modelData.actions)

                        model: actionsModel
                        delegate: Rectangle {
                            color: Theme.bgColor
                            bottomLeftRadius: index === 0 ? Theme.radius : 0
                            bottomRightRadius: actionBtnRepeater.count - 1 === index ? Theme.radius : 0
                            border {
                                color: Theme.border.color
                                width: Theme.border.width
                            }
                            anchors {
                                top: parent.top
                                bottom: parent.bottom
                            }
                            width: parent.width / actionBtnRepeater.count

                            Text {
                                text: modelData.text
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
                                acceptedButtons: Qt.LeftButton;
                                onClicked: modelData.invoke();
                            }
                        }
                    }
                }
            }
            header: Column {
                Item {
                    width: listView.width
                    height: Theme.notifPanel.spacing
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                ClippingRectangle {
                    visible: NotificationService.popups.isOverflow ? true : false

                    width: listView.width
                    height: Theme.notifs.height / 3

                    color: Theme.bgColor
                    radius: Theme.radius
                    border {
                        color: Theme.border.color
                        width: Theme.border.width
                    }
                    anchors {
                        top: parent.top
                    }

                    Text {
                        text: `+${NotificationService.popups.overflowCount} more notification(s)`
                        color: Theme.textColor
                        font {
                            family: Theme.font.family
                            pixelSize: Theme.font.size
                        }
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
}
