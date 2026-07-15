import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

// --- ADD THIS LINE TO FIND Theme.qml ---
import "../../../"

RowLayout {
    id: root
    spacing: 8

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink ? sink.audio.muted : false
    readonly property real volume: sink ? sink.audio.volume : 0
    readonly property int segmentCount: 10

    // Keeps the sink's properties live-updated
    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }

    function setVolumeFromRatio(ratio) {
        if (!sink) return
        const clamped = Math.max(0, Math.min(1, ratio))
        sink.audio.volume = clamped
        if (clamped > 0 && sink.audio.muted)
            sink.audio.muted = false
    }

    // Mute toggle, styled like the SDDM theme's tactical buttons
    // (dark fill, thin idle border, border brightens to accent on hover)
    Rectangle {
        id: muteBtn
        implicitWidth: 44
        implicitHeight: 20
        Layout.alignment: Qt.AlignVCenter
        color: Theme.bgPanel
        border.width: muteArea.containsMouse ? 2 : 1
        border.color: muteArea.containsMouse
            ? (root.muted ? Theme.error : Theme.accent)
            : Theme.borderIdle

        Text {
            anchors.centerIn: parent
            text: root.muted ? "MUTE" : "AUD"
            font.family: Theme.fontFamily
            font.pixelSize: 9
            font.bold: true
            color: root.muted ? Theme.error : Theme.textMuted
        }

        MouseArea {
            id: muteArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: if (root.sink) root.sink.audio.muted = !root.sink.audio.muted
        }
    }

    // Segmented HUD meter — the bar's one signature element.
    // Click/drag anywhere on it to set volume, scroll to nudge it.
    Item {
        id: meterWrap
        implicitWidth: root.segmentCount * 6 + (root.segmentCount - 1) * 3
        implicitHeight: 16
        Layout.alignment: Qt.AlignVCenter

        readonly property int filled: Math.round(root.volume * root.segmentCount)

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 3

            Repeater {
                model: root.segmentCount
                delegate: Rectangle {
                    width: 6
                    height: 12
                    color: index >= meterWrap.filled
                        ? Theme.bgPanel
                        : (root.muted ? Theme.textMuted : Theme.accent)
                    border.width: 1
                    border.color: index >= meterWrap.filled ? Theme.borderIdle : "transparent"
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: (mouse) => root.setVolumeFromRatio(mouse.x / width)
            onPositionChanged: (mouse) => { if (pressed) root.setVolumeFromRatio(mouse.x / width) }
            onWheel: (wheel) => {
                const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                root.setVolumeFromRatio(root.volume + step)
            }
        }
    }

    Text {
        Layout.preferredWidth: 30
        Layout.alignment: Qt.AlignVCenter
        text: root.muted ? "--" : Math.round(root.volume * 100) + "%"
        font.family: Theme.fontFamily
        font.pixelSize: 10
        color: Theme.textMuted
        horizontalAlignment: Text.AlignRight
    }
}
