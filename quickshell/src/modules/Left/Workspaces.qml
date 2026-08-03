import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import "../../../"

RowLayout {
    id: root
    spacing: 10

    Repeater {
        model: 9

        Item {
            id: wsItem
            implicitWidth: isActive ? 22 : (hasWindows ? 8 : 6)
            implicitHeight: 6

            Layout.alignment: Qt.AlignVCenter

            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            property bool hasWindows: !!ws

            Behavior on implicitWidth { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

            Rectangle {
                anchors.fill: parent
                radius: 1
                
                color: wsItem.isActive 
                    ? Theme.monowireYellow 
                    : (wsItem.hasWindows ? Theme.textMain : Theme.borderIdle)
                
                opacity: wsItem.isActive ? 1.0 : (wsItem.hasWindows ? 0.7 : 0.3)
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("workspace " + (index + 1))
            }
        }
    }
}