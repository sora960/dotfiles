// Custom Edgerunner Unified HUD Interface
import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

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
            Component.onCompleted: bgVideo.play()
        }

        Rectangle {
            id: tintLayer
            anchors.fill: parent
            color: "#05070c"
            opacity: parseFloat(config.DimBackgroundImage || "0.20")
            z: 1
        }

        // --- TACTICAL EDGE HUD LAYOUT ---
        Item {
            id: tacticalContainer
            width: 360
            height: 440
            anchors.left: parent.left
            anchors.leftMargin: 90
            anchors.verticalCenter: parent.verticalCenter
            z: 2

            // Top Asymmetric Header Block
            Rectangle {
                id: headerBar
                width: parent.width
                height: 28
                color: config.AccentColor
                anchors.top: parent.top

                Text {
                    text: "01  DATA_LINK_ESTABLISHED"
                    font.family: config.Font
                    font.bold: true
                    font.pixelSize: 10
                    color: "#0b0f19"
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "SYS.INIT"
                    font.family: config.Font
                    font.pixelSize: 9
                    color: "#0b0f19"
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // High-Tech Outer Wireframe Box
            Rectangle {
                anchors.top: headerBar.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                color: "#dd0b0f19"
                border.color: config.AccentColor
                border.width: 1

                // Bottom Corner Accent Marks
                Rectangle { width: 16; height: 3; color: config.AccentColor; anchors.bottom: parent.bottom; anchors.left: parent.left }
                Rectangle { width: 3; height: 16; color: config.AccentColor; anchors.bottom: parent.bottom; anchors.left: parent.left }

                // --- INTERNAL HUD ELEMENTS CONTAINER ---
                Column {
                    anchors.fill: parent
                    anchors.margins: 28
                    spacing: 16

                    // Header Status
                    Text {
                        text: "LOGIN_REQUIRED"
                        font.family: config.Font
                        font.bold: true
                        font.pixelSize: 22
                        color: root.palette.text
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // System Clock & Date Matrix
                    Column {
                        width: parent.width
                        spacing: 2
                        
                        Text {
                            id: timeText
                            text: Qt.formatTime(new Date(), config.HourFormat || "HH:mm")
                            font.family: config.Font
                            font.pixelSize: 32
                            color: root.palette.text
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text {
                            id: dateText
                            text: Qt.formatDate(new Date(), config.DateFormat || "yyyy-MM-dd")
                            font.family: config.Font
                            font.pixelSize: 11
                            color: "#64748b"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Timer {
                            interval: 1000; running: true; repeat: true
                            onTriggered: {
                                timeText.text = Qt.formatTime(new Date(), config.HourFormat || "HH:mm")
                                dateText.text = Qt.formatDate(new Date(), config.DateFormat || "yyyy-MM-dd")
                            }
                        }
                    }

                    // Spacer
                    Item { width: 1; height: 10 }

                    // USER_ID Input
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
                        color: root.palette.text
                        background: Rectangle {
                            color: "#111622"
                            border.color: username.activeFocus ? config.AccentColor : "#334155"
                            border.width: username.activeFocus ? 2 : 1
                        }
                        KeyNavigation.down: password
                    }

                    // PASSWORD Input
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
                        color: root.palette.text
                        background: Rectangle {
                            color: "#111622"
                            border.color: password.activeFocus ? config.AccentColor : "#334155"
                            border.width: password.activeFocus ? 2 : 1
                        }
                        onAccepted: if (username.text !== "" && password.text !== "") sddm.login(username.text, password.text, 0)
                        KeyNavigation.down: revealSecret
                    }

                    // Reveal Secret Checkbox Row
                    CheckBox {
                        id: revealSecret
                        width: parent.width
                        height: 20
                        
                        indicator: Rectangle {
                            id: indicatorBox
                            implicitHeight: 12; implicitWidth: 12
                            color: "#111622"
                            border.color: revealSecret.activeFocus || revealSecret.hovered ? config.AccentColor : "#334155"
                            anchors.verticalCenter: parent.verticalCenter
                            Rectangle {
                                anchors.centerIn: parent; implicitHeight: 6; implicitWidth: 6; color: config.AccentColor
                                visible: revealSecret.checked
                            }
                        }
                        contentItem: Text {
                            text: config.TranslateShowPassword || "SHOW PASSWORD"
                            font.family: config.Font; font.pixelSize: 9
                            color: revealSecret.hovered ? config.AccentColor : "#64748b"
                            anchors.left: indicatorBox.right; anchors.leftMargin: 6; anchors.verticalCenter: indicatorBox.verticalCenter
                        }
                        KeyNavigation.down: loginButton
                    }

                    // AUTHORIZE Action Bar
                    Button {
                        id: loginButton
                        width: parent.width
                        height: 40
                        text: config.TranslateLogin || "AUTHORIZE"
                        hoverEnabled: true
                        enabled: username.text !== "" && password.text !== ""

                        contentItem: Text {
                            text: loginButton.text
                            font.family: config.Font; font.bold: true; font.pixelSize: 12
                            color: "#0b0f19"
                            horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: loginButton.hovered ? Qt.lighter(config.AccentColor, 1.1) : config.AccentColor
                            opacity: loginButton.enabled ? 1.0 : 0.4
                        }
                        onClicked: sddm.login(username.text, password.text, 0)
                    }
                }
            }
        }
    }
}
