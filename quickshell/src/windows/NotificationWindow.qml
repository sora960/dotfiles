import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../"

PanelWindow {
    id: notifWindow

    // =========================================================
    // 🛠️ TWEAKABLE SETTINGS
    // =========================================================
    property int cardWidth: 360
    property int cardTimeoutMs: 5000
    property int cardSpacing: 10
    property int screenMarginTop: 20
    property int screenMarginRight: 20
    property int iconSize: 32
    // =========================================================

    anchors {
        top: true
        right: true
    }

    margins {
        top: notifWindow.screenMarginTop
        right: notifWindow.screenMarginRight
    }

    WlrLayershell.layer: WlrLayer.Overlay

    // 1. Safe JavaScript array. No raw C++ pointers exposed to UI bindings!
    property var activeToasts: []

    implicitWidth: activeToasts.length > 0 ? notifWindow.cardWidth : 0
    implicitHeight: notifColumn.implicitHeight
    color: "transparent"

    NotificationServer {
        id: notifServer
        bodySupported: true
        actionsSupported: true
        imageSupported: true

        onNotification: (notif) => {
            notif.tracked = true   // claim it so the server won't free it under you
            var list = [...notifWindow.activeToasts];
            list.push({
                uid: Math.random().toString(),
                summary: notif.summary ? notif.summary : "Notification",
                body: notif.body ? notif.body : "",
                appIcon: notif.appIcon ? notif.appIcon : "",
                image: notif.image ? notif.image : "",
                backend: notif
            });
            notifWindow.activeToasts = list;
        }
    }

    Column {
        id: notifColumn
        width: notifWindow.cardWidth
        spacing: notifWindow.cardSpacing

        // Slide up animation when an item is removed
        move: Transition {
            NumberAnimation { properties: "y"; duration: 200; easing.type: Easing.OutQuad }
        }

        Repeater {
            model: notifWindow.activeToasts

            delegate: Rectangle {
                id: toastCard
                width: notifColumn.width
                
                property bool popupVisible: true
                
                // Notice: No "modelData !== null" checks here anymore. Pure, safe UI logic.
                visible: popupVisible
                implicitHeight: visible ? 80 : 0
                opacity: visible ? 1 : 0

                Behavior on opacity { NumberAnimation { duration: 180 } }

                color: Theme.bgPanel || "#141824"
                border.color: Theme.borderIdle || "#252E3F"
                border.width: visible ? 1 : 0

                Component.onDestruction: {
                    expireTimer.stop();
                    destroyTimer.stop();
                }

                Timer {
                    id: expireTimer
                    running: true
                    interval: notifWindow.cardTimeoutMs
                    repeat: false
                    onTriggered: {
                        toastCard.popupVisible = false; // Trigger fade-out
                        destroyTimer.start();
                    }
                }

                Timer {
                    id: destroyTimer
                    interval: 180 // Wait for fade to finish
                    repeat: false
                    onTriggered: {
                        var list = [...notifWindow.activeToasts];
                        // Find by our custom JS string ID, completely avoiding C++ pointer comparisons
                        var idx = list.findIndex(t => t.uid === modelData.uid);
                        if (idx !== -1) {
                            list.splice(idx, 1);
                            notifWindow.activeToasts = list;
                        }
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12
                    visible: toastCard.visible

                    Rectangle {
                        Layout.preferredWidth: notifWindow.iconSize
                        Layout.preferredHeight: notifWindow.iconSize
                        Layout.alignment: Qt.AlignVCenter
                        color: "#080A12"
                        border.color: Theme.borderIdle || "#252E3F"
                        border.width: 1

                        IconImage {
                            anchors.fill: parent
                            anchors.margins: 4
                            source: {
                                if (modelData.image && modelData.image !== "") return modelData.image;
                                if (modelData.appIcon && modelData.appIcon !== "") {
                                    var resolved = Quickshell.iconPath(modelData.appIcon);
                                    if (resolved && resolved !== "") return resolved;
                                }
                                return Quickshell.iconPath("preferences-system-notifications") || "";
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 2

                        Text {
                            Layout.fillWidth: true
                            // Evaluating primitive safe strings, crash impossible
                            text: modelData.summary 
                            color: Theme.accent || "#8ECAE6"
                            font.family: Theme.fontFamily || "JetBrains Mono"
                            font.pixelSize: 13
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Text {
                            Layout.fillWidth: true
                            text: modelData.body
                            color: Theme.textMain || "#E2E8F0"
                            font.family: Theme.fontFamily || "JetBrains Mono"
                            font.pixelSize: 11
                            wrapMode: Text.Wrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        id: closeButton
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24
                        Layout.alignment: Qt.AlignVCenter
                        cursorShape: Qt.PointingHandCursor

                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            color: closeButton.containsMouse ? "#FFFFFF" : (Theme.textMuted || "#52637A")
                            font.pixelSize: 12
                        }

                        onClicked: {
                            toastCard.popupVisible = false;
                            destroyTimer.start();
                            // Safely wrapped best-effort native dismiss
                            try {
                                if (modelData.backend) {
                                    modelData.backend.dismiss();
                                }
                            } catch(e) {}
                        }
                    }
                }
            }
        }
    }
}