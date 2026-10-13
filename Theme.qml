pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property color bg: Qt.rgba(0.078, 0.078, 0.078, 0.92)
    readonly property color fg: "#e6e6e6"
    readonly property color dim: "#888888"
    readonly property color accent: "#33ccff"
    readonly property color warn: "#ffcc66"
    readonly property color crit: "#ff6666"
    readonly property color anvil: "#99ccff"
    readonly property string font: "JetBrains Mono"
    readonly property int size: 12
    readonly property int pad: 10
    readonly property int barH: 28
    readonly property int panelW: 360
    readonly property int panelPad: 14
    readonly property int titleSize: 16
    readonly property int captionSize: 11
    readonly property int displaySize: 28
    readonly property int labelW: 118
    readonly property color panelBg: "#161616"
    readonly property color panelBorder: "#2a2a2a"
}
