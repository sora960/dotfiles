import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../"

PanelWindow {
    id: launcherWindow

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: isOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    implicitWidth: isOpen ? 420 : 0
    implicitHeight: isOpen ? 320 : 0
    color: "transparent"

    property bool isOpen: false
    property int selectedIndex: 0

    IpcHandler {
        target: "applauncher"

        function toggle(): void {
            launcherWindow.isOpen = !launcherWindow.isOpen;
            if (launcherWindow.isOpen) {
                searchInput.text = "";
                launcherWindow.selectedIndex = 0;
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        visible: launcherWindow.isOpen

        color: Theme.bgPanel
        border.color: Theme.borderIdle
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

            // 1. SEARCH INPUT
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 38
                color: "#080A12"
                border.color: searchInput.activeFocus ? (Theme.accent || "#8ECAE6") : Theme.borderIdle
                border.width: 1

                TextField {
                    id: searchInput
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    placeholderText: "Search applications..."
                    color: Theme.textMain || "#E2E8F0"
                    placeholderTextColor: Theme.textMuted || "#52637A"
                    font.family: Theme.fontFamily || "JetBrains Mono"
                    font.pixelSize: 13
                    background: null

                    // Focus automatically when opened
                    onVisibleChanged: {
                        if (visible) forceActiveFocus();
                    }

                    // Reset selected highlight on typing
                    onTextChanged: launcherWindow.selectedIndex = 0

                    // Key Bindings & Navigation
                    Keys.onEscapePressed: launcherWindow.isOpen = false

                    Keys.onDownPressed: (event) => {
                        if (resultsListView.count > 0) {
                            launcherWindow.selectedIndex = Math.min(launcherWindow.selectedIndex + 1, resultsListView.count - 1);
                        }
                        event.accepted = true;
                    }

                    Keys.onUpPressed: (event) => {
                        if (resultsListView.count > 0) {
                            launcherWindow.selectedIndex = Math.max(launcherWindow.selectedIndex - 1, 0);
                        }
                        event.accepted = true;
                    }

                    Keys.onReturnPressed: {
                        if (resultsListView.count > 0 && launcherWindow.selectedIndex < resultsListView.count) {
                            var currentItem = filteredModel.values[launcherWindow.selectedIndex];
                            if (currentItem) {
                                currentItem.execute();
                                launcherWindow.isOpen = false;
                            }
                        }
                    }
                }
            }

            // 2. FILTERED RESULTS LIST
            ListView {
                id: resultsListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 2
                currentIndex: launcherWindow.selectedIndex

                // QuickShell's ScriptModel reactively filters DesktopEntries
                model: ScriptModel {
                    id: filteredModel
                    values: DesktopEntries.applications.values.filter(app => {
                        if (!app) return false;
                        var query = searchInput.text.trim().toLowerCase();
                        if (query === "") return true;
                        
                        var nameMatch = app.name && app.name.toLowerCase().includes(query);
                        var commentMatch = app.comment && app.comment.toLowerCase().includes(query);
                        return nameMatch || commentMatch;
                    })
                }

                delegate: Item {
                    id: appItem
                    width: resultsListView.width
                    height: 38

                    readonly property bool isSelected: index === launcherWindow.selectedIndex

                    // Background selection highlight
                    Rectangle {
                        anchors.fill: parent
                        color: appItem.isSelected ? (Theme.bgHover || "#1A1E2E") : (itemMouseArea.containsMouse ? "#111524" : "transparent")
                        border.color: appItem.isSelected ? (Theme.accent || "#8ECAE6") : "transparent"
                        border.width: appItem.isSelected ? 1 : 0
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 12

                        IconImage {
                            width: 24
                            height: 24
                            source: Quickshell.iconPath(modelData.icon)
                        }

                        Text {
                            Layout.fillWidth: true
                            text: modelData.name
                            color: appItem.isSelected ? "#FFFFFF" : (Theme.textMain || "#E2E8F0")
                            font.family: Theme.fontFamily || "JetBrains Mono"
                            font.pixelSize: 13
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        id: itemMouseArea
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: launcherWindow.selectedIndex = index

                        onClicked: {
                            modelData.execute();
                            launcherWindow.isOpen = false;
                        }
                    }
                }
            }
        }
    }
}