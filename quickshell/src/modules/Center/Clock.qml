import Quickshell
import QtQuick
import QtQuick.Layouts

// --- ADD THIS LINE TO FIND Theme.qml ---
import "../../../"

ColumnLayout {
    id: root
    spacing: 0

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDateTime(clock.date, "hh:mm")
        font.family: Theme.fontFamily
        font.bold: true
        font.pixelSize: 14
        color: Theme.textMain
    }

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDateTime(clock.date, "yyyy-MM-dd")
        font.family: Theme.fontFamily
        font.pixelSize: 9
        color: Theme.textMuted
    }
}
