// src/windows/Bar.qml
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
    id: bar
    anchors.top: true
    anchors.left: true
    anchors.right: true
    
    color: "transparent" 
    implicitHeight: 34 

    readonly property int lWidth: leftContent.implicitWidth + 32
    readonly property int cWidth: centerContent.implicitWidth + 40
    readonly property int rWidth: rightContent.implicitWidth + 32

    SeamlessBarShape {
        anchors.fill: parent
        leftWidth: bar.lWidth
        centerWidth: bar.cWidth
        rightWidth: bar.rWidth
    }

    Item {
        width: bar.lWidth; height: parent.height; anchors.left: parent.left
        RowLayout {
            id: leftContent
            anchors.centerIn: parent
            spacing: 12
            ArchLogo {}
            Rectangle { width: 1; height: 12; color: Theme.borderIdle; opacity: 0.3 }
            Workspaces {}
        }
    }

    Item {
        width: bar.cWidth; height: parent.height; anchors.horizontalCenter: parent.horizontalCenter
        RowLayout {
            id: centerContent
            anchors.centerIn: parent
            Clock {}
        }
    }

    Item {
        width: bar.rWidth; height: parent.height; anchors.right: parent.right
        RowLayout {
            id: rightContent
            anchors.centerIn: parent
            VolumeMeter {}
        }
    }
}