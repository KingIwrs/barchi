import QtQuick
import Quickshell

import "../utils/"


PanelWindow {
    id: root
    required property var modelData

	property list<Item> leftItems
	property list<Item> centerItems
	property list<Item> rightItems

    anchors {
        top: true
        left: true
        right: true
    }

    screen: modelData
    implicitHeight: Theme.height
    color: "transparent"

    margins {
        top: Theme.marginTop
        left: Theme.marginLeft
        right: Theme.marginRight
    }

    Row {
        id: left
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.spacing
    }

    Row {
        id: centre
        anchors {
            centerIn: parent
            verticalCenter: parent.verticalCenter
        }
        spacing: Theme.spacing
    }

    Row {
        id: right
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        spacing: Theme.spacing
    }

	Component.onCompleted: {
		for (var item of leftItems) { item.parent = left; item.anchors.verticalCenter = left.verticalCenter; }
		for (var item of centerItems) { item.parent = centre; item.anchors.verticalCenter = centre.verticalCenter; }
		for (var item of rightItems) { item.parent = right; item.anchors.verticalCenter = right.verticalCenter; }
	}
}
