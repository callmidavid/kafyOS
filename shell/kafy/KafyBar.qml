import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import "theme" as Kafy

Scope {
    id: root
    required property var shell
    required property var notifications
    property string time: Qt.formatTime(new Date(), "ddd, MMM d  hh:mm")
    Kafy.KafyTheme { id: theme }

    Timer { interval: 1000; running: true; repeat: true; onTriggered: root.time = Qt.formatTime(new Date(), "ddd, MMM d  hh:mm") }

    Variants {
        model: Quickshell.screens
        delegate: Component {
            PanelWindow {
                required property var modelData
                screen: modelData
                anchors { top: true; left: true; right: true }
                margins { top: 8; left: 12; right: 12 }
                implicitHeight: 38
                exclusiveZone: 46
                color: "transparent"

                Rectangle {
                    anchors.fill: parent; radius: 14; color: theme.surface; border.width: 1; border.color: theme.outline
                    Row {
                        anchors.left: parent.left; anchors.leftMargin: 14; anchors.verticalCenter: parent.verticalCenter; spacing: 8
                        Text { text: "Kafy"; color: theme.accent; font.bold: true; font.pixelSize: 14 }
                        Repeater {
                            model: Hyprland.workspaces
                            delegate: Rectangle {
                                required property var modelData
                                width: 20; height: 20; radius: 10; color: modelData.focused ? theme.accent : "transparent"
                                Text { anchors.centerIn: parent; text: modelData.id > 0 ? modelData.id : modelData.name; color: modelData.focused ? theme.surface : theme.muted; font.pixelSize: 11 }
                                MouseArea { anchors.fill: parent; onClicked: modelData.activate() }
                            }
                        }
                    }
                    Text { anchors.centerIn: parent; text: root.time; color: theme.text; font.weight: Font.DemiBold; font.pixelSize: 13 }
                    Row {
                        anchors.right: parent.right; anchors.rightMargin: 12; anchors.verticalCenter: parent.verticalCenter; spacing: 12
                        Text { text: "⌁"; color: theme.text; font.pixelSize: 16; MouseArea { anchors.fill: parent; onClicked: Quickshell.execDetached(["nm-connection-editor"]) } }
                        Text { text: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled ? "ᛒ" : ""; color: theme.text; font.pixelSize: 15; MouseArea { anchors.fill: parent; onClicked: root.shell.controlCenterOpen = !root.shell.controlCenterOpen } }
                        Text { text: UPower.displayDevice.isLaptopBattery ? Math.round(UPower.displayDevice.percentage) + "%" : ""; color: theme.text; font.pixelSize: 12 }
                        Text { text: root.notifications.trackedNotifications.values.length > 0 ? "●" : ""; color: theme.accent; font.pixelSize: 13; MouseArea { anchors.fill: parent; onClicked: root.shell.notificationCenterOpen = !root.shell.notificationCenterOpen } }
                        Text { text: "⚙"; color: theme.accentSoft; font.pixelSize: 15; MouseArea { anchors.fill: parent; onClicked: root.shell.controlCenterOpen = !root.shell.controlCenterOpen } }
                    }
                }
            }
        }
    }
}
