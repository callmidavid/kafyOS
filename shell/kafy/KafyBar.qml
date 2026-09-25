import QtQuick
import Quickshell
import Quickshell.Hyprland
import "theme" as Kafy

Scope {
    id: root
    property string time: Qt.formatTime(new Date(), "hh:mm")

    Kafy.KafyTheme {
        id: theme
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.time = Qt.formatTime(new Date(), "hh:mm")
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                required property var modelData
                screen: modelData

                anchors {
                    top: true
                    left: true
                    right: true
                }

                margins {
                    top: 52
                    left: 12
                    right: 12
                }

                implicitHeight: 36
                color: "transparent"
                exclusiveZone: 0

                Rectangle {
                    anchors.fill: parent
                    radius: 14
                    color: theme.surface
                    border.width: 1
                    border.color: theme.outline

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Text {
                            text: "Kafy"
                            color: theme.accent
                            font.bold: true
                            font.pixelSize: 14
                        }

                        Repeater {
                            model: Hyprland.workspaces

                            delegate: Rectangle {
                                required property var modelData
                                width: 18
                                height: 18
                                radius: 9
                                color: modelData.focused ? theme.accent : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.id > 0 ? modelData.id : modelData.name
                                    color: modelData.focused ? theme.surface : theme.muted
                                    font.pixelSize: 11
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: modelData.activate()
                                }
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: root.time
                        color: theme.text
                        font.weight: Font.DemiBold
                        font.pixelSize: 13
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                        text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : "Kafy OS"
                        color: theme.muted
                        elide: Text.ElideRight
                        width: parent.width * 0.28
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: 12
                    }
                }
            }
        }
    }
}
