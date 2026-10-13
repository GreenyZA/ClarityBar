import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: chip
    required property var barWindow
    implicitWidth: btn.implicitWidth
    implicitHeight: Theme.barH

    BarChip {
        id: btn
        anchors.fill: parent
        label: StatsSource.netIp.length ? StatsSource.netIp : "net ?"
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
                title: "Network"
                status: (StatsSource.netDet.state || "?").toUpperCase() + "  "
                    + StatsSource.nvl(StatsSource.netDet.iface, "")
                big: ""
            }
            SectionLabel {
                title: "ADDRESS"
            }
            StatRow {
                label: "IP Address"
                value: StatsSource.nvl(StatsSource.netDet.cidr, StatsSource.netIp)
            }
            StatRow {
                label: "Gateway"
                value: StatsSource.nvl(StatsSource.netDet.gateway, "?")
            }
            StatRow {
                label: "MAC"
                value: StatsSource.nvl(StatsSource.netDet.mac, "?")
            }
            SectionLabel {
                title: "TRAFFIC"
            }
            StatRow {
                label: "Receiving"
                value: StatsSource.nvl(StatsSource.netDet.rx_rate, "?")
            }
            StatRow {
                label: "Sending"
                value: StatsSource.nvl(StatsSource.netDet.tx_rate, "?")
            }
            StatRow {
                label: "Received"
                value: StatsSource.nvl(StatsSource.netDet.rx, "?")
            }
            StatRow {
                label: "Sent"
                value: StatsSource.nvl(StatsSource.netDet.tx, "?")
            }
            Text {
                text: "click to copy IP"
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: copyProc.running = true
                }
            }

            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: "No stored credentials. Gateway and DNS are read from network state only."
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
        }
    }

    Process {
        id: copyProc
        command: ["wl-copy", StatsSource.netIp]
        running: false
    }
}
