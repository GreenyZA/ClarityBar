import Quickshell.Hyprland
import QtQuick

Row {
    spacing: 0

    Repeater {
        model: Hyprland.workspaces

        Chip {
            required property var modelData
            visible: modelData && modelData.id >= 1
            label: "" + modelData.id
            color: modelData.focused ? Theme.accent : Theme.dim
            onClicked: Hyprland.dispatch("workspace " + modelData.id)
        }
    }
}
