//@ pragma UseQApplication

import QtQuick
import Quickshell
import "./modules/bar/"
import "./modules/widgets/"

Scope {
    Variants {
        model: Quickshell.screens
        delegate: Bar {
            leftItems: [
                SysTray {
                    // activeOutput: screen.name === "DP-1"
                },
                Notifications {},
            ]
            centerItems: [
                AWName {
                    maxWidth: 90
                    // activeOutput: screen.name === "DP-1"
                },
            ]

            rightItems: [
                Audio {},
                BluetoothNNet {
                    // activeOutput: screen.name === "DP-1"
                },
                DateTime {},
            ]
        }
    }
    AudioOSD {}
}
