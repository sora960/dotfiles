import QtQuick
import Quickshell.Io

import "../../../"

Item {
    id: root
    implicitWidth: 20
    implicitHeight: 20

    // Properties for system state
    property int updateCount: 0
    property bool isCritical: false

    Process {
        id: pacmanCheck
        command: ["sh", "-c", "checkupdates | wc -l"]
        running: true
        
        stdout: StdioCollector {
            onStreamFinished: {
                let count = parseInt(this.text.trim());
                root.updateCount = isNaN(count) ? 0 : count;
            }
        }
    }

    Timer {
        interval: 1800000 
        running: true
        repeat: true
        onTriggered: pacmanCheck.running = true
    }

    Text {
        id: logo
        anchors.centerIn: parent
        text: "󰣇"
        font.family: Theme.fontFamily
        font.pixelSize: 20

        // Multi-State Color Logic:
        // 1. Critical Alarm -> Red (Theme.error)
        // 2. Updates Available -> Monowire Yellow (Theme.monowireYellow)
        // 3. Normal Idle State -> Clean Moon-Grey (Theme.textMain)
        color: root.isCritical 
            ? Theme.error 
            : (root.updateCount > 0 ? Theme.monowireYellow : Theme.textMain)

        // Soft breathing pulse when updates are pending
        SequentialAnimation on opacity {
            running: root.updateCount > 0 && !root.isCritical
            loops: Animation.Infinite
            NumberAnimation { to: 0.4; duration: 2000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
        }

        opacity: root.updateCount > 0 ? 1.0 : 0.85

        Behavior on color { ColorAnimation { duration: 300 } }
    }
}