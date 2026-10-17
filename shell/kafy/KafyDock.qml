import QtQuick
import Quickshell
import "theme" as Kafy

Scope {
    id: root
    required property var shell
    Kafy.KafyTheme { id: theme }
    Variants { model: Quickshell.screens; delegate: Component { PanelWindow {
        required property var modelData; screen: modelData
        anchors { bottom: true }; margins { bottom: 14 }; implicitWidth: 300; implicitHeight: 58; exclusiveZone: 0; color: "transparent"
        Rectangle { anchors.fill: parent; radius: 18; color: theme.surface; border.width: 1; border.color: theme.outline
            Row { anchors.centerIn: parent; spacing: 12
                Repeater { model: [{name:"Firefox",command:["firefox"]},{name:"Files",command:["thunar"]},{name:"Terminal",command:["foot"]}]
                    delegate: Rectangle { required property var modelData; width: 72; height: 40; radius: 12; color: "#18ffffff"
                        Text { anchors.centerIn: parent; text: modelData.name; color: theme.text; font.pixelSize: 11 }
                        MouseArea { anchors.fill: parent; onClicked: Quickshell.execDetached(modelData.command) }
                    }
                }
            }
        }
    }}}
}
