import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../shapes/"
import "../modules/Left/"
import "../modules/Center/"
import "../modules/Right/"

import "../../"

PanelWindow {
    id: topBar
    anchors.top: true
    anchors.left: true
    anchors.right: true
    
    color: "transparent" 
    implicitHeight: 34 

    // Windows cleanly align below the islands
    exclusiveZone: 20

    readonly property int lWidth: leftContent.implicitWidth + 10
    readonly property int cWidth: centerContent.implicitWidth + 10
    readonly property int rWidth: rightContent.implicitWidth + 10

    Item {
        id: barContent
        anchors.fill: parent

        // Island shape background
        SeamlessBarShape {
            anchors.fill: parent
            leftWidth: topBar.lWidth
            centerWidth: topBar.cWidth
            rightWidth: topBar.rWidth
        }

        // Left Island Content
        Item {
            width: topBar.lWidth
            height: parent.height
            anchors.left: parent.left

            RowLayout {
                id: leftContent
                anchors.centerIn: parent
                spacing: 12
                ArchLogo {}
                Rectangle { 
                    width: 1
                    height: 12
                    color: Theme.borderIdle
                    opacity: 0.3
                    radius: 0
                }
                Workspaces {}
            }
        }

        // Center Island Content
        Item {
            width: topBar.cWidth
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout {
                id: centerContent
                anchors.centerIn: parent
                Clock {}
            }
        }

        // Right Island Content
        Item {
            width: topBar.rWidth
            height: parent.height
            anchors.right: parent.right

            RowLayout {
                id: rightContent
                anchors.centerIn: parent
                VolumeMeter {}
            }
        }
    }
}