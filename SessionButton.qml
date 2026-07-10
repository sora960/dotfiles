import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: sessionButton
    height: 40
    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter

    property var selectedSession: selectSession.currentIndex
    property string textConstantSession
    property int loginButtonWidth
    property Control exposeSession: selectSession

    ComboBox {
        id: selectSession
        anchors.fill: parent
        hoverEnabled: true
        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"

        // The Dropdown Session List Panel Setup
        popup: Popup {
            y: parent.height
            width: parent.width
            implicitHeight: contentItem.implicitHeight
            padding: 0

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex
            }

            background: Rectangle {
                color: "#111622"
                border.color: "#334155"
                border.width: 1
                radius: 0
            }
        }

        // Dropdown Entry Rows Formatting
        delegate: ItemDelegate {
            width: parent.width
            height: 40
            hoverEnabled: true
            
            contentItem: Text {
                text: model.name.toUpperCase()
                font.family: config.Font
                font.pointSize: 9
                font.bold: true
                color: selectSession.highlightedIndex === index ? "#0b0f19" : "#94a3b8"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: selectSession.highlightedIndex === index ? config.AccentColor : "transparent"
                radius: 0
            }
        }

        // Selected Interface Display Styling
        contentItem: Text {
            text: "SYS.INTERFACE // " + selectSession.currentText.toUpperCase()
            font.family: config.Font
            font.pointSize: 9
            font.bold: true
            color: "#94a3b8"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            color: "#111622"
            border.color: selectSession.activeFocus || selectSession.hovered ? config.AccentColor : "#334155"
            border.width: selectSession.activeFocus || selectSession.hovered ? 2 : 1
            radius: 0
        }

        indicator: Canvas {
            id: canvas
            x: selectSession.width - width - 15
            y: (selectSession.height - height) / 2
            width: 10
            height: 6
            contextType: "2d"
            connections: {
                target: selectSession
                onPopupVisibleChanged: canvas.requestPaint()
            }
            onPaint: {
                context.reset();
                context.moveTo(0, 0);
                context.lineTo(width, 0);
                context.lineTo(width / 2, height);
                context.closePath();
                context.fillStyle = selectSession.hovered ? config.AccentColor : "#64748b";
                context.fill();
            }
        }
    }
}
