import QtQuick
import QtQuick.Controls
import Quickshell
import "theme" as Kafy

PanelWindow {
    id: root
    required property var shell
    visible: shell.launcherOpen
    anchors { top: true; bottom: true; left: true; right: true }
    exclusiveZone: 0
    color: "#80000000"
    focusable: true
    Kafy.KafyTheme { id: theme }

    Rectangle {
        width: Math.min(parent.width * 0.62, 720); height: Math.min(parent.height * 0.72, 620)
        anchors.centerIn: parent; radius: 20; color: theme.surface; border.width: 1; border.color: theme.outline
        property string query: ""
        Keys.onEscapePressed: root.shell.launcherOpen = false
        Column {
            anchors.fill: parent; anchors.margins: 22; spacing: 14
            TextField { id: search; width: parent.width; placeholderText: "Search apps"; focus: root.visible; onTextChanged: parent.parent.query = text; Keys.onEscapePressed: root.shell.launcherOpen = false }
            ListView {
                width: parent.width; height: parent.height - 58; clip: true
                model: ScriptModel { values: DesktopEntries.applications.values.filter(app => app.name.toLowerCase().includes(parent.parent.query.toLowerCase()) || app.genericName.toLowerCase().includes(parent.parent.query.toLowerCase())) }
                delegate: Item {
                    required property var modelData
                    width: ListView.view.width; height: 54
                    Text { anchors.left: parent.left; anchors.leftMargin: 12; anchors.verticalCenter: parent.verticalCenter; text: modelData.name; color: theme.text; font.pixelSize: 15 }
                    Text { anchors.right: parent.right; anchors.rightMargin: 12; anchors.verticalCenter: parent.verticalCenter; text: modelData.genericName; color: theme.muted; font.pixelSize: 12 }
                    MouseArea { anchors.fill: parent; onClicked: { modelData.execute(); root.shell.launcherOpen = false } }
                }
            }
        }
    }
}
