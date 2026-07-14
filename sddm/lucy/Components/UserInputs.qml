import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: inputGroup
    width: parent.width
    spacing: 16

    property alias usernameText: username.text
    property alias passwordText: password.text
    property alias usernameFocus: username.activeFocus
    property alias passwordFocus: password.activeFocus
    property bool loginFailed: false
    
    // Focus Routing Cables
    property Item navUp: null
    property Item navDown: null
    property alias focusTop: username
    property alias focusBottom: revealSecret

    signal accepted()

    function clearPassword() {
        password.text = ""
    }

    function forcePasswordFocus() {
        password.forceActiveFocus()
    }

    TextField {
        id: username
        width: parent.width
        height: 38
        text: userModel.lastUser
        font.family: config.Font
        font.pixelSize: 11
        placeholderText: config.TranslatePlaceholderUsername || "USER_ID"
        selectByMouse: true
        horizontalAlignment: TextInput.AlignHCenter
        verticalAlignment: TextInput.AlignVCenter
        color: config.MainColor || "#ffffff"
        background: Rectangle {
            color: "#111622"
            border.color: username.activeFocus ? (inputGroup.loginFailed ? "#ef4444" : config.AccentColor) : "#334155"
            border.width: username.activeFocus ? 2 : 1
        }
        
        KeyNavigation.up: inputGroup.navUp
        KeyNavigation.down: password
    }

    Column {
        width: parent.width
        spacing: 4

        TextField {
            id: password
            width: parent.width
            height: 38
            font.family: config.Font
            font.pixelSize: 11
            focus: config.ForcePasswordFocus == "true"
            placeholderText: config.TranslatePlaceholderPassword || "PASSWORD"
            selectByMouse: true
            echoMode: revealSecret.checked ? TextInput.Normal : TextInput.Password
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            passwordCharacter: "•"
            color: config.MainColor || "#ffffff"
            background: Rectangle {
                color: "#111622"
                border.color: password.activeFocus ? (inputGroup.loginFailed ? "#ef4444" : config.AccentColor) : "#334155"
                border.width: password.activeFocus ? 2 : 1
            }
            onAccepted: inputGroup.accepted()
            
            KeyNavigation.up: username
            KeyNavigation.down: revealSecret
        }

        Text {
            text: "WARNING // CAPS_LOCK_ACTIVE"
            font.family: config.Font
            font.bold: true
            font.pixelSize: 8
            color: "#ef4444"
            visible: typeof sddm !== "undefined" && sddm.capsLock === true
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    CheckBox {
        id: revealSecret
        width: parent.width
        height: 20
        
        indicator: Rectangle {
            id: indicatorBox
            implicitHeight: 12; implicitWidth: 12
            color: "#111622"
            border.color: revealSecret.activeFocus || revealSecret.hovered ? (inputGroup.loginFailed ? "#ef4444" : config.AccentColor) : "#334155"
            anchors.verticalCenter: parent.verticalCenter
            Rectangle {
                anchors.centerIn: parent; implicitHeight: 6; implicitWidth: 6; color: inputGroup.loginFailed ? "#ef4444" : config.AccentColor
                visible: revealSecret.checked
            }
        }
        contentItem: Text {
            text: config.TranslateShowPassword || "SHOW PASSWORD"
            font.family: config.Font; font.pixelSize: 9
            color: revealSecret.hovered ? (inputGroup.loginFailed ? "#ef4444" : config.AccentColor) : "#64748b"
            anchors.left: indicatorBox.right; anchors.leftMargin: 6; anchors.verticalCenter: indicatorBox.verticalCenter
        }
        
        KeyNavigation.up: password
        KeyNavigation.down: inputGroup.navDown
    }
}
