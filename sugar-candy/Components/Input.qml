// Custom Edgerunner Text Input Fields Configuration
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Column {
    id: inputContainer
    Layout.fillWidth: true
    spacing: 12

    property Control exposeSession: sessionSelect.exposeSession
    property bool failed

    Item {
        id: usernameField
        height: 40
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter

        TextField {
            id: username
            text: config.ForceLastUser == "true" ? userModel.lastUser : null
            font.family: config.Font
            font.pointSize: 10
            anchors.fill: parent
            placeholderText: config.TranslatePlaceholderUsername || "USER_ID"
            selectByMouse: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            renderType: Text.QtRendering
            color: root.palette.text

            background: Rectangle {
                color: "#111622"
                border.color: username.activeFocus ? config.AccentColor : "#334155"
                border.width: username.activeFocus ? 2 : 1
            }
            onAccepted: loginButton.clicked()
            KeyNavigation.down: password
        }
    }

    Item {
        id: passwordField
        height: 40
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter

        TextField {
            id: password
            anchors.fill: parent
            font.family: config.Font
            font.pointSize: 10
            focus: config.ForcePasswordFocus == "true" ? true : false
            selectByMouse: true
            echoMode: revealSecret.checked ? TextInput.Normal : TextInput.Password
            placeholderText: config.TranslatePlaceholderPassword || "PASSWORD"
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            passwordCharacter: "•"
            renderType: Text.QtRendering
            color: root.palette.text

            background: Rectangle {
                color: "#111622"
                border.color: password.activeFocus ? config.AccentColor : "#334155"
                border.width: password.activeFocus ? 2 : 1
            }
            onAccepted: loginButton.clicked()
            KeyNavigation.down: revealSecret
        }
    }

    Item {
        id: secretCheckBox
        height: 24
        width: parent.width

        CheckBox {
            id: revealSecret
            anchors.left: parent.left
            hoverEnabled: true

            indicator: Rectangle {
                id: indicatorBox
                implicitHeight: 14
                implicitWidth: 14
                color: "#111622"
                border.color: revealSecret.activeFocus || revealSecret.hovered ? config.AccentColor : "#334155"
                border.width: 1

                Rectangle {
                    anchors.centerIn: parent
                    implicitHeight: 8
                    implicitWidth: 8
                    color: config.AccentColor
                    visible: revealSecret.checked
                }
            }

            contentItem: Text {
                text: config.TranslateShowPassword || "SHOW PASSWORD"
                font.family: config.Font
                font.pixelSize: 10
                color: revealSecret.hovered ? config.AccentColor : "#94a3b8"
                anchors.left: indicatorBox.right
                anchors.leftMargin: 8
                anchors.verticalCenter: indicatorBox.verticalCenter
            }
            KeyNavigation.down: loginButton
        }
    }

    Item {
        height: 16
        width: parent.width
        Label {
            id: errorMessage
            text: failed ? config.TranslateLoginFailedWarning || "ACCESS_DENIED" : keyboard.capsLock ? config.TranslateCapslockWarning || "CAPS LOCK ACTIVE" : ""
            font.family: config.Font
            font.pixelSize: 10
            color: "#ef4444"
            visible: failed || keyboard.capsLock
            anchors.centerIn: parent
        }
    }

    Item {
        id: login
        height: 42
        width: parent.width

        Button {
            id: loginButton
            anchors.fill: parent
            text: config.TranslateLogin || "AUTHORIZE"
            hoverEnabled: true

            contentItem: Text {
                text: loginButton.text
                font.family: config.Font
                font.bold: true
                font.pixelSize: 12
                color: loginButton.hovered ? "#0b0f19" : "#0b0f19"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: loginButton.hovered ? Qt.lighter(config.AccentColor, 1.1) : config.AccentColor
                opacity: loginButton.enabled ? 1.0 : 0.4
            }

            onClicked: sddm.login(username.text, password.text, sessionSelect.selectedSession)
            KeyNavigation.down: sessionSelect.exposeSession
        }
    }

    SessionButton {
        id: sessionSelect
        textConstantSession: "INTERFACE"
        loginButtonWidth: parent.width
    }

    Connections {
        target: sddm
        onLoginFailed: {
            failed = true
            resetError.start()
        }
    }

    Timer {
        id: resetError
        interval: 3000
        onTriggered: failed = false
        running: false
    }
}
