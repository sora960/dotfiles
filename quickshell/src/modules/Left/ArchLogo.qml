import QtQuick
import Quickshell.Io // Necessary for background process checks

// --- ADD THIS LINE TO FIND Theme.qml ---
import "../../../"

Item {
    id: root
    implicitWidth: 20
    implicitHeight: 20

    // Properties for system state
    property int updateCount: 0
    property bool isCritical: false // Can map to high temperatures or crash triggers later

    // background check for pending pacman/AUR updates
    Process {
        id: pacmanCheck
        // Uses pacman -Qu (quiet update check). Returns 1 if no updates.
        command: ["sh", "-c", "checkupdates | wc -l"]
        running: true
        
        stdout: StdioCollector {
            onStreamFinished: {
                let count = parseInt(this.text.trim());
                root.updateCount = isNaN(count) ? 0 : count;
            }
        }
    }

    // Refresh update status every 30 minutes
    Timer {
        interval: 1800000 
        running: true
        repeat: true
        onTriggered: pacmanCheck.running = true
    }

    Text {
        id: logo
        anchors.centerIn: parent
        text: "󰣇" // Nerd Font Arch Icon
        font.family: Theme.fontFamily
        font.pixelSize: 20

        // Multi-State Color Logic:
        // 1. Critical Alarm (Red) 
        // 2. Updates Available (Mellow Lucy Lavender/Pink)
        // 3. Normal / Empty State (Quiet Night Slate Blue)
        color: root.isCritical 
            ? Theme.error 
            : (root.updateCount > 0 ? Theme.characterAccent : Theme.textMuted)

        // Soft, organic breathing pulse if there are active updates waiting
        SequentialAnimation on opacity {
            running: root.updateCount > 0 && !root.isCritical
            loops: Animation.Infinite
            NumberAnimation { to: 0.4; duration: 2000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.9; duration: 2000; easing.type: Easing.InOutSine }
        }

        // Keep it static and dim if there are no updates
        opacity: root.updateCount > 0 ? 0.9 : 0.4

        Behavior on color { ColorAnimation { duration: 300 } }
    }
}