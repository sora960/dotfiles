import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../../"

PanelWindow {
    id: bottomdock

    anchors.bottom: true
    // Shrinked compact width
    implicitWidth: 400
    implicitHeight: 60
    exclusiveZone: 0

    property bool isOpen: false

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            bottomdock.isOpen = !bottomdock.isOpen;
        }
    }

    margins {
        bottom: isOpen ? 12 : -implicitHeight
    }

    Behavior on margins.bottom {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.bgPanel
        border.color: Theme.borderIdle

        ListView {
            id: iconListView
            anchors.fill: parent
            anchors.margins: 14

            orientation: ListView.Horizontal
            spacing: 16
            clip: true

            model: DesktopEntries.applications

            // Mouse wheel handler for smooth horizontal scrolling
            WheelHandler {
                id: wheelHandler
                orientation: Qt.Horizontal
                onWheel: (event) => {
                    if (event.angleDelta.y < 0 || event.angleDelta.x < 0) {
                        iconListView.flick(500, 0)  // Scroll right
                    } else {
                        iconListView.flick(-500, 0) // Scroll left
                    }
                }
            }

            delegate: Item {
                id: delegateItem
                width: 40
                height: 40
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined

                // Hover highlight box
                Rectangle {
                    anchors.fill: parent
                    color: itemMouseArea.containsMouse ? (Theme.bgHover || Theme.bgPanel) : "transparent"
                }

                // App Icon
                IconImage {
                    width: 32
                    height: 32
                    anchors.centerIn: parent
                    source: Quickshell.iconPath(modelData.icon)
                }

                // Click area
                MouseArea {
                    id: itemMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        modelData.execute()
                        bottomdock.isOpen = false
                    }
                }
            }
        }
    }
}