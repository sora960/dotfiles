import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import "../../"

PanelWindow {
    id: noteWindow

    property int panelWidth: 360
    property int panelHeight: 420
    property string notePath: Quickshell.env("HOME") + "/.config/schedule/sticky.txt"

    visible: false
    implicitWidth: panelWidth
    implicitHeight: panelHeight
    color: "transparent"

    anchors { top: true; right: true }
    margins { top: 20; right: 20 }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: noteWindow.visible
        ? WlrKeyboardFocus.Exclusive
        : WlrKeyboardFocus.None

    // qs ipc call note toggle
    IpcHandler {
        target: "note"
        function toggle(): void { noteWindow.visible = !noteWindow.visible }
    }

    FileView {
        id: noteFile
        path: noteWindow.notePath
        blockLoading: true // read is instant/small, avoid a blank flash on open
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bgPanel || "#141824"
        border.color: Theme.borderIdle || "#252E3F"
        border.width: 1

        TextArea {
            id: noteArea
            anchors.fill: parent
            anchors.margins: 12
            text: noteFile.text()
            color: Theme.textMain || "#E2E8F0"
            font.family: Theme.fontFamily || "JetBrains Mono"
            font.pixelSize: 13
            wrapMode: TextArea.Wrap
            background: null

            // Debounced autosave — writes 600ms after you stop typing
            onTextChanged: saveTimer.restart()
        }

        Timer {
            id: saveTimer
            interval: 600
            onTriggered: noteFile.setText(noteArea.text)
        }

        Keys.onEscapePressed: noteWindow.visible = false
        focus: noteWindow.visible
    }
}
