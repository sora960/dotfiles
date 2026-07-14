import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "Components" as LucyComp

Pane {
    id: root

    height: config.ScreenHeight || Screen.height
    width: config.ScreenWidth || Screen.width

    padding: 0
    palette.button: config.AccentColor
    palette.highlight: config.AccentColor
    palette.text: config.MainColor
    palette.buttonText: config.OverrideLoginButtonTextColor
    palette.window: config.BackgroundColor

    font.family: config.Font
    font.pointSize: 11
    focus: true

    Item {
        id: sizeHelper
        anchors.fill: parent

        Video {
            id: bgVideo
            source: config.Background
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectCrop
            loops: MediaPlayer.Infinite
            autoPlay: true
            volume: 0.0
        }

        Rectangle {
            id: tintLayer
            anchors.fill: parent
            color: "#05070c"
            opacity: parseFloat(config.DimBackgroundImage || "0.20")
            z: 1
        }

        Item {
            id: tacticalContainer
            width: 360
            height: 560
            anchors.left: parent.left
            anchors.leftMargin: 90
            anchors.verticalCenter: parent.verticalCenter
            z: 2

            property bool loginFailed: false

            transform: Translate {
                id: glitchTranslate
                x: 0
            }

            SequentialAnimation {
                id: glitchShake
                NumberAnimation { target: glitchTranslate; property: "x"; to: -16; duration: 40; easing.type: Easing.InOutQuad }
                NumberAnimation { target: glitchTranslate; property: "x"; to: 20; duration: 40; easing.type: Easing.InOutQuad }
                NumberAnimation { target: glitchTranslate; property: "x"; to: -12; duration: 40; easing.type: Easing.InOutQuad }
                NumberAnimation { target: glitchTranslate; property: "x"; to: 8; duration: 30; easing.type: Easing.InOutQuad }
                NumberAnimation { target: glitchTranslate; property: "x"; to: -4; duration: 30; easing.type: Easing.InOutQuad }
                NumberAnimation { target: glitchTranslate; property: "x"; to: 0; duration: 20; easing.type: Easing.InOutQuad }
                onStopped: glitchTranslate.x = 0
            }

            Timer {
                id: resetFail
                interval: 2000
                repeat: false
                onTriggered: tacticalContainer.loginFailed = false
            }

            Rectangle {
                id: headerBar
                width: parent.width
                height: 28
                color: tacticalContainer.loginFailed ? "#ef4444" : config.AccentColor
                anchors.top: parent.top

                Text {
                    text: tacticalContainer.loginFailed ? "01  CRITICAL_ERR // ACCESS_DENIED" : "01  DATA_LINK_ESTABLISHED"
                    font.family: config.Font
                    font.bold: true
                    font.pixelSize: 10
                    color: tacticalContainer.loginFailed ? "#ffffff" : "#0b0f19"
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "SYS.INIT"
                    font.family: config.Font
                    font.pixelSize: 9
                    color: tacticalContainer.loginFailed ? "#ffffff" : "#0b0f19"
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                anchors.top: headerBar.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                color: "#dd0b0f19"
                border.color: tacticalContainer.loginFailed ? "#ef4444" : config.AccentColor
                border.width: 1

                // Four-Corner Accents
                Rectangle { width: 16; height: 3; color: tacticalContainer.loginFailed ? "#ef4444" : config.AccentColor; anchors.bottom: parent.bottom; anchors.left: parent.left }
                Rectangle { width: 3; height: 16; color: tacticalContainer.loginFailed ? "#ef4444" : config.AccentColor; anchors.bottom: parent.bottom; anchors.left: parent.left }
                Rectangle { width: 16; height: 3; color: tacticalContainer.loginFailed ? "#ef4444" : config.AccentColor; anchors.bottom: parent.bottom; anchors.right: parent.right }
                Rectangle { width: 3; height: 16; color: tacticalContainer.loginFailed ? "#ef4444" : config.AccentColor; anchors.bottom: parent.bottom; anchors.right: parent.right }
                Rectangle { width: 16; height: 3; color: tacticalContainer.loginFailed ? "#ef4444" : config.AccentColor; anchors.top: parent.top; anchors.left: parent.left }
                Rectangle { width: 3; height: 16; color: tacticalContainer.loginFailed ? "#ef4444" : config.AccentColor; anchors.top: parent.top; anchors.left: parent.left }
                Rectangle { width: 16; height: 3; color: tacticalContainer.loginFailed ? "#ef4444" : config.AccentColor; anchors.top: parent.top; anchors.right: parent.right }
                Rectangle { width: 3; height: 16; color: tacticalContainer.loginFailed ? "#ef4444" : config.AccentColor; anchors.top: parent.top; anchors.right: parent.right }

                Column {
                    anchors.fill: parent
                    anchors.margins: 28
                    spacing: 16

                    Text {
                        text: "LOGIN_REQUIRED"
                        font.family: config.Font
                        font.bold: true
                        font.pixelSize: 22
                        color: root.palette.text
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    LucyComp.Clock {
                        id: clockModule
                    }

                    Item { width: 1; height: 4 }

                    LucyComp.UserInputs {
                        id: userInputsModule
                        loginFailed: tacticalContainer.loginFailed
                        
                        // Link precisely to the buttons
                        navUp: systemControlsModule.shutdownBtn
                        navDown: loginButton.enabled ? loginButton : sessionSelector.exposeSession

                        onAccepted: {
                            if (usernameText !== "" && passwordText !== "")
                                sddm.login(usernameText, passwordText, sessionSelector.selectedSession)
                        }
                    }

                    Button {
                        id: loginButton
                        width: parent.width
                        height: 40
                        text: config.TranslateLogin || "AUTHORIZE"
                        hoverEnabled: true
                        enabled: userInputsModule.usernameText !== "" && userInputsModule.passwordText !== ""

                        contentItem: Text {
                            text: loginButton.text
                            font.family: config.Font; font.bold: true; font.pixelSize: 12
                            color: "#0b0f19"
                            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: loginButton.hovered ? Qt.lighter(tacticalContainer.loginFailed ? "#ef4444" : config.AccentColor, 1.1) : (tacticalContainer.loginFailed ? "#ef4444" : config.AccentColor)
                            opacity: loginButton.enabled ? 1.0 : 0.4
                        }
                        onClicked: sddm.login(userInputsModule.usernameText, userInputsModule.passwordText, sessionSelector.selectedSession)
                        
                        // Link directly into the bottom of the input module
                        KeyNavigation.up: userInputsModule.focusBottom
                        KeyNavigation.down: sessionSelector.exposeSession
                    }

                    LucyComp.SessionButton {
                        id: sessionSelector
                        navigationUp: loginButton.enabled ? loginButton : userInputsModule.focusBottom
                        navigationDown: systemControlsModule.rebootBtn
                    }

                    LucyComp.SystemControls {
                        id: systemControlsModule
                        isFailed: tacticalContainer.loginFailed
                        navUp: sessionSelector.exposeSession
                        // Close the loop back to the top
                        navDown: userInputsModule.focusTop
                    }
                }
            }
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            tacticalContainer.loginFailed = true
            userInputsModule.clearPassword()
            userInputsModule.forcePasswordFocus()
            glitchShake.restart()
            resetFail.restart()
        }
    }
}
