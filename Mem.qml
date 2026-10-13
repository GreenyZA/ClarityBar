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
        label: "mem " + StatsSource.memPct + "%"
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
                title: "Memory"
                status: StatsSource.nvl(StatsSource.memDet.used_gb, "?") + " GB used of "
                    + StatsSource.nvl(StatsSource.memDet.total_gb, "?") + " GB"
                big: StatsSource.memPct + "%"
            }
            Rectangle {
                width: parent.width
                height: 8
                color: "#222"
                Rectangle {
                    width: parent.width * Math.min(1, StatsSource.memPct / 100)
                    height: parent.height
                    color: StatsSource.memPct >= 90 ? Theme.crit : Theme.accent
                }
            }
            SectionLabel {
                title: "BREAKDOWN"
            }
            StatRow {
                label: "Used"
                value: StatsSource.nvl(StatsSource.memDet.used_gb, "?") + " GB"
            }
            StatRow {
                label: "Available"
                value: StatsSource.nvl(StatsSource.memDet.avail_gb, "?") + " GB"
            }
            StatRow {
                label: "Cached"
                value: StatsSource.nvl(StatsSource.memDet.cached_gb, "?") + " GB"
            }
            StatRow {
                label: "Swap"
                value: StatsSource.nvl(StatsSource.memDet.swap_used_gb, "?") + " / "
                    + StatsSource.nvl(StatsSource.memDet.swap_total_gb, "?") + " GB"
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: "procfs only. Includes page cache and buffers on acer (host .10)."
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
        }
    }
}
