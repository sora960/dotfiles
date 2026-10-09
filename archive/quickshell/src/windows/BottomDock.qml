import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../../"

PanelWindow {
    id: bottomdock

    anchors.bottom: true
    implicitWidth: 400
    implicitHeight: 60
    exclusiveZone: 0

    // Receive state from shell.qml
    property bool isOpen: false
    
    // Signal to tell shell.qml to close the dock
    signal requestClose()

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

            WheelHandler {
                id: wheelHandler
                orientation: Qt.Horizontal
                onWheel: (event) => {
                    if (event.angleDelta.y < 0 || event.angleDelta.x < 0) {
                        iconListView.flick(500, 0)
                    } else {
                        iconListView.flick(-500, 0)
                    }
                }
            }

            delegate: Item {
                id: delegateItem
                width: 40
                height: 40
                anchors.verticalCenter: parent ? parent.verticalCenter : undefined

                Rectangle {
                    anchors.fill: parent
                    color: itemMouseArea.containsMouse ? (Theme.bgHover || Theme.bgPanel) : "transparent"
                }

                IconImage {
                    width: 32
                    height: 32
                    anchors.centerIn: parent
                    source: Quickshell.iconPath(modelData.icon)
                }

                MouseArea {
                    id: itemMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        modelData.execute()
                        // Tell root to close the dock instead of doing it locally
                        bottomdock.requestClose()
                    }
                }
            }
        }
    }
}