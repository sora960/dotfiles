import Quickshell
import Quickshell.Io
import QtQuick

import "src/windows"

ShellRoot {
    id: root
    
    // Global state for the docks
    property bool isDockOpen: false

    // Global IPC Handler manages the state
    IpcHandler {
        target: "launcher"

        function toggle(): void {
            root.isDockOpen = !root.isDockOpen;
        }
    }

    Variants {
        model: Quickshell.screens

        TopBar {
            required property var modelData
            screen: modelData
        }
    }

    Variants {
        model: Quickshell.screens

        BottomDock {
            required property var modelData
            screen: modelData
            
            // Bind dock state to global state
            isOpen: root.isDockOpen
            
            // Listen for the dock asking to close (e.g., when an app is clicked)
            onRequestClose: root.isDockOpen = false
        }
    }

    NotificationWindow {}
    AppLauncherWindow {}
}