import QtQuick
import Quickshell
import "theme" as Kafy

PanelWindow {
    id: root
    required property var shell
    required property var notifications
    visible: shell.notificationCenterOpen
    anchors { top: true; right: true }
    margins { top: 56; right: 12 }
    implicitWidth: 360; implicitHeight: 420
    exclusiveZone: 0; color: "transparent"; focusable: true
    Kafy.KafyTheme { id: theme }
    Rectangle {
        anchors.fill: parent; radius: 18; color: theme.surface; border.width: 1; border.color: theme.outline
        Column {
            anchors.fill: parent; anchors.margins: 18; spacing: 12
            Row { width: parent.width
                Text { text: "Notifications"; color: theme.text; font.pixelSize: 18; font.bold: true }
                Item { width: parent.width - 210; height: 1 }
                Text { text: "Clear"; color: theme.accent; MouseArea { anchors.fill: parent; onClicked: notifications.trackedNotifications.values.forEach(notification => notification.dismiss()) } }
            }
            ListView { width: parent.width; height: parent.height - 45; clip: true; model: notifications.trackedNotifications
                delegate: Rectangle { required property var modelData; width: ListView.view.width; height: Math.max(64, bodyText.implicitHeight + 42); radius: 12; color: "#18ffffff"
                    Text { anchors.left: parent.left; anchors.top: parent.top; anchors.margins: 12; text: modelData.summary; color: theme.text; font.bold: true }
                    Text { id: bodyText; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.margins: 12; text: modelData.body; color: theme.muted; wrapMode: Text.WordWrap }
                    MouseArea { anchors.fill: parent; onClicked: modelData.dismiss() }
                }
            }
        }
    }
}
