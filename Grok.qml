import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: chip
    required property var barWindow
    property int pct: -1
    property string plan: ""
    property string name: "Grok"
    property string resets: ""
    property string today: ""
    property var prompts: null
    property string updated: ""
    property bool ok: false

    implicitWidth: btn.implicitWidth
    implicitHeight: Theme.barH

    BarChip {
        id: btn
        anchors.fill: parent
        label: chip.ok && chip.pct >= 0 ? "grok " + chip.pct + "%" : "grok ?"
        labelColor: chip.pct >= 80 ? Theme.crit : (chip.pct >= 70 ? Theme.warn : Theme.fg)
        onClicked: pop.visible = !pop.visible
    }

    Process {
        id: proc
        command: ["/home/warpuppy/.local/bin/tf-bar-grok"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var obj = JSON.parse(this.text.trim());
                    chip.ok = !!obj.ok;
                    chip.pct = obj.pct === null || obj.pct === undefined ? -1 : obj.pct;
                    chip.plan = obj.plan || "";
                    chip.name = obj.name || "Grok";
                    chip.resets = obj.resets || "";
                    chip.today = obj.today || "";
                    chip.prompts = obj.prompts;
                    chip.updated = obj.updated || "";
                } catch (e) {}
            }
        }
    }

    Timer {
        interval: 30000
        repeat: true
        running: true
        onTriggered: proc.running = true
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
                title: chip.name
                status: (chip.plan || "weekly pool").toUpperCase()
                big: chip.pct >= 0 ? chip.pct + "%" : "?"
            }
            Rectangle {
                width: parent.width
                height: 8
                color: "#222"
                Rectangle {
                    width: parent.width * Math.min(1, Math.max(0, chip.pct) / 100)
                    height: parent.height
                    color: chip.pct >= 80 ? Theme.crit : (chip.pct >= 70 ? Theme.warn : Theme.accent)
                }
            }
            SectionLabel {
                title: "WEEKLY"
            }
            StatRow {
                label: "Used"
                value: chip.pct >= 0 ? chip.pct + "% of SuperGrok pool" : "?"
            }
            StatRow {
                label: "Resets"
                value: chip.resets.length ? chip.resets : "?"
            }
            StatRow {
                label: "Updated"
                value: chip.updated.length ? chip.updated : "?"
            }
            SectionLabel {
                title: "TODAY"
            }
            StatRow {
                label: "Tokens"
                value: chip.today.length ? chip.today : "?"
            }
            StatRow {
                label: "Prompts"
                value: chip.prompts !== null && chip.prompts !== undefined ? "" + chip.prompts : "?"
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: "Today tokens include cache. Weekly % is the billed pool."
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
        }
    }
}
