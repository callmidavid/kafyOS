import QtQuick
import Quickshell
import Quickshell.Bluetooth
import "theme" as Kafy

PanelWindow {
    id: root
    required property var shell
    required property var notifications
    visible: shell.controlCenterOpen
    anchors { top: true; right: true }
    margins { top: 56; right: 12 }
    implicitWidth: 340; implicitHeight: 300
    exclusiveZone: 0; color: "transparent"; focusable: true
    Kafy.KafyTheme { id: theme }
    Rectangle {
        anchors.fill: parent; radius: 18; color: theme.surface; border.width: 1; border.color: theme.outline
        Column {
            anchors.fill: parent; anchors.margins: 18; spacing: 12
            Text { text: "Control Center"; color: theme.text; font.pixelSize: 18; font.bold: true }
            Text { text: "Everyday controls stay in Kafy, not a separate panel app."; color: theme.muted; wrapMode: Text.WordWrap; width: parent.width }
            Row { spacing: 10
                Repeater { model: ["Network", "Bluetooth", "Audio"]
                    delegate: Rectangle { required property string modelData; width: 92; height: 42; radius: 12; color: "#18ffffff"
                        Text { anchors.centerIn: parent; text: modelData; color: theme.text; font.pixelSize: 12 }
                        MouseArea { anchors.fill: parent; onClicked: {
                            if (modelData === "Network") Quickshell.execDetached(["nm-connection-editor"])
                            else if (modelData === "Bluetooth") { if (Bluetooth.defaultAdapter) Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled }
                            else Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
                        }}
                    }
                }
            }
            Rectangle { width: parent.width; height: 42; radius: 12; color: "#18ffffff"
                Text { anchors.centerIn: parent; text: "Sound settings"; color: theme.text }
                MouseArea { anchors.fill: parent; onClicked: Quickshell.execDetached(["wpctl", "status"]) }
            }
            Rectangle { width: parent.width; height: 42; radius: 12; color: "#18ffffff"
                Text { anchors.centerIn: parent; text: "Open system settings"; color: theme.text }
                MouseArea { anchors.fill: parent; onClicked: Quickshell.execDetached(["nm-connection-editor"]) }
            }
        }
    }
}
