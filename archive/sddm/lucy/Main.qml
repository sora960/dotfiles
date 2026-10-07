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
        anchors.fill: parent

        // 1. Background Video (Can be swapped to Image in theme.conf)
        Video {
            id: bgVideo
            source: config.Background
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectCrop
            loops: MediaPlayer.Infinite
            autoPlay: true
            volume: 0.0
        }

        // 2. Subtle Dark Tint for Readability
        Rectangle {
            anchors.fill: parent
            color: "#05070c"
            opacity: parseFloat(config.DimBackgroundImage || "0.30")
        }

        // 3. The Minimalist "Floating Island" Login Panel
        Rectangle {
            id: loginPanel
            width: 320
            height: 480
            anchors.left: parent.left
            anchors.leftMargin: 120
            anchors.verticalCenter: parent.verticalCenter
            
            color: "#880b0f19" // Semi-transparent dark blue/black
            radius: 8 // Matches your QuickShell floating islands
            border.color: loginFailed ? "#ef4444" : "#22ffffff"
            border.width: 1
            
            property bool loginFailed: false

            Timer {
                id: resetFail
                interval: 2000
                repeat: false
                onTriggered: loginPanel.loginFailed = false
            }

            Column {
                anchors.fill: parent
                anchors.margins: 32
                spacing: 16

                Text {
                    text: loginPanel.loginFailed ? "ACCESS DENIED" : "WELCOME"
                    font.family: config.Font
                    font.bold: true
                    font.pixelSize: 18
                    color: loginPanel.loginFailed ? "#ef4444" : root.palette.text
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                LucyComp.Clock { id: clockModule }

                Item { width: 1; height: 12 } // Spacer

                LucyComp.UserInputs {
                    id: userInputsModule
                    loginFailed: loginPanel.loginFailed
                    navUp: systemControlsModule.shutdownBtn
                    // PATCH 1: Re-route downward loop straight to the login button asset
                    navDown: loginButton
                    onAccepted: {
                        if (usernameText !== "" && passwordText !== "")
                            // PATCH 2: Hardcode login session index to 0 (our active hyprland-uwsm target)
                            sddm.login(usernameText, passwordText, 0)
                    }
                }

                Button {
                    id: loginButton
                    width: parent.width
                    height: 40
                    text: config.TranslateLogin || "LOGIN"
                    hoverEnabled: true
                    enabled: userInputsModule.usernameText !== "" && userInputsModule.passwordText !== ""

                    contentItem: Text {
                        text: loginButton.text
                        font.family: config.Font; font.bold: true; font.pixelSize: 12
                        color: "#0b0f19"
                        horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: loginButton.hovered ? Qt.lighter(config.AccentColor, 1.1) : config.AccentColor
                        opacity: loginButton.enabled ? 1.0 : 0.4
                        radius: 4
                    }
                    // PATCH 2 (cont.): Hardcode default login execution index parameter
                    onClicked: sddm.login(userInputsModule.usernameText, userInputsModule.passwordText, 0)
                    
                    KeyNavigation.up: userInputsModule.focusBottom
                    // PATCH 3: Re-route downward loop straight to the reboot key node
                    KeyNavigation.down: systemControlsModule.rebootBtn
                }

                // NUKE TARGET: LucyComp.SessionButton block has been cleanly deleted from here

                LucyComp.SystemControls {
                    id: systemControlsModule
                    isFailed: loginPanel.loginFailed
                    // PATCH 4: Re-route upward navigation to land back on the loginButton safely
                    navUp: loginButton
                    navDown: userInputsModule.focusTop
                }
            }
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            loginPanel.loginFailed = true
            userInputsModule.clearPassword()
            userInputsModule.forcePasswordFocus()
            resetFail.restart()
        }
    }
}
