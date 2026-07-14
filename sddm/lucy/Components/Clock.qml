import QtQuick 2.15

Column {
    id: clockRoot
    width: parent.width
    spacing: 2
    
    Text {
        id: timeText
        text: Qt.formatTime(new Date(), config.HourFormat || "HH:mm")
        font.family: config.Font
        font.pixelSize: 32
        color: config.MainColor || "#ffffff"
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
