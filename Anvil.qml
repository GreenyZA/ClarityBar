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
        label: StatsSource.anvilLabel
        labelColor: Theme.anvil
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
                title: "Anvil"
                status: "LEN OVO HELPER  192.168.1.8:9129"
                big: "ANVIL"
            }
            SectionLabel {
                title: "STATUS"
            }
            StatRow {
                label: "Bar"
                value: StatsSource.nvl(StatsSource.anvilDet.raw, StatsSource.anvilLabel)
            }
            StatRow {
                label: "Endpoint"
                value: "192.168.1.8:9129"
            }
            StatRow {
                label: "Service"
                value: "helper-status + CMDB (backup host .8)"
            }
            SectionLabel {
                title: "ACTIONS"
            }
            Text {
                text: "open status page"
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: Theme.size
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: openProc.running = true
                }
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: "CMDB snapshots and fleet sync logs remain authoritative; status page mirrors host health."
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
        }
    }

    Process {
        id: openProc
        command: ["brave", "http://192.168.1.8:9129/"]
        running: false
    }
}