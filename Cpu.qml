import Quickshell
import QtQuick

Item {
    id: chip
    required property var barWindow
    implicitWidth: btn.implicitWidth
    implicitHeight: Theme.barH

    BarChip {
        id: btn
        anchors.fill: parent
        label: "cpu " + StatsSource.cpuPct + "%"
        onClicked: pop.visible = !pop.visible
    }

    PopupWindow {
        id: pop
        visible: false
        grabFocus: true
        anchor.window: chip.barWindow
        anchor.item: chip
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        implicitWidth: box.implicitWidth
        implicitHeight: box.implicitHeight

        PanelBox {
            id: box
            Hero {
                title: "CPU"
                status: StatsSource.nvl(StatsSource.cpuDet.model, "Ryzen")
                big: StatsSource.cpuPct + "%"
            }
            SectionLabel {
                title: "LOAD"
            }
            StatRow {
                label: "Load 1 / 5 / 15"
                value: StatsSource.nvl(StatsSource.cpuDet.load1, "?") + "  "
                    + StatsSource.nvl(StatsSource.cpuDet.load5, "?") + "  "
                    + StatsSource.nvl(StatsSource.cpuDet.load15, "?")
            }
            StatRow {
                label: "Temperature"
                value: StatsSource.cpuDet.temp !== undefined ? StatsSource.cpuDet.temp + "°C" : "?"
            }
            StatRow {
                label: "Clock"
                value: StatsSource.cpuDet.freq_mhz ? StatsSource.cpuDet.freq_mhz + " MHz" : "?"
            }
            StatRow {
                label: "Threads"
                value: "" + StatsSource.nvl(StatsSource.cpuDet.cores, "?")
            }
            SectionLabel {
                title: "CORES"
            }
            Row {
                spacing: 4
                Repeater {
                    model: StatsSource.cpuCore
                    Rectangle {
                        required property var modelData
                        width: 36
                        height: 36
                        color: "#222"

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: parent.height * Math.min(1, (modelData.pct || 0) / 100)
                            color: (modelData.pct || 0) >= 85 ? Theme.crit : Theme.accent
                        }

                        Text {
                            anchors.centerIn: parent
                            text: (modelData.pct || 0) + ""
                            color: Theme.fg
                            font.family: Theme.font
                            font.pixelSize: 10
                            z: 1
                        }
                    }
                }
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: "Thermal sensor is optional; logiqx scan covers acer's Ryzen (host .10)."
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
        }
    }
}
