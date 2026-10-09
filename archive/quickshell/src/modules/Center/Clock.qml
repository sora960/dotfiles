import Quickshell
import QtQuick
import QtQuick.Layouts

import "../../../"

RowLayout {
    id: root
    spacing: 8

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // 1. DIGITAL TIME (Monowire Yellow)
    Text {
        text: Qt.formatDateTime(clock.date, "hh:mm")
        font.family: Theme.fontFamily
        font.bold: true
        font.pixelSize: 13
        color: Theme.monowireYellow
    }


    // 3. DATE READOUT (MON JUL 27)
    Text {
        text: Qt.formatDateTime(clock.date, "ddd MMM dd").toUpperCase()
        font.family: Theme.fontFamily
        font.pixelSize: 11
        font.letterSpacing: 1
        color: Theme.textMain
    }
}