import QtQuick 2.15
import QtQuick.Controls 2.15

Row {
    width: parent.width
    spacing: 8

    property bool isFailed: false
    property Item navUp: null
    property Item navDown: null
    property alias rebootBtn: rebootButton
    property alias shutdownBtn: shutdownButton

    Button {
        id: rebootButton
        width: (parent.width - 8) / 2
        height: 32
        text: "REBOOT"
        hoverEnabled: true
        onClicked: sddm.reboot()

        contentItem: Text {
            text: parent.text
            font.family: config.Font
            font.pixelSize: 9
            font.bold: true
            color: parent.hovered ? (parent.isFailed ? "#ef4444" : config.AccentColor) : "#64748b"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            color: "#111622"
            border.color: parent.hovered ? (parent.isFailed ? "#ef4444" : config.AccentColor) : "#334155"
            border.width: parent.hovered ? 2 : 1
        }
        
        KeyNavigation.up: parent.navUp
        KeyNavigation.down: parent.navDown
        KeyNavigation.right: shutdownButton
    }

    Button {
        id: shutdownButton
        width: (parent.width - 8) / 2
        height: 32
        text: "SHUTDOWN"
        hoverEnabled: true
        onClicked: sddm.powerOff()

        contentItem: Text {
            text: parent.text
            font.family: config.Font
            font.pixelSize: 9
            font.bold: true
            color: parent.hovered ? (parent.isFailed ? "#ef4444" : config.AccentColor) : "#64748b"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            color: "#111622"
            border.color: parent.hovered ? (parent.isFailed ? "#ef4444" : config.AccentColor) : "#334155"
            border.width: parent.hovered ? 2 : 1
        }
        
        KeyNavigation.up: parent.navUp
        KeyNavigation.down: parent.navDown
        KeyNavigation.left: rebootButton
    }
}
