import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: chip
    required property var barWindow
    property bool llamaOk: false
    property string llamaModel: "none"
    property string grokPct: "?"
    property int grokPctInt: -1

    implicitWidth: btn.implicitWidth
    implicitHeight: Theme.barH

    function refresh() {
        llamaProc.running = true
        grokProc.running = true
    }

    BarChip {
        id: btn
        anchors.fill: parent
        label: chip.llamaOk ? "ai up" : "ai ?"
        labelColor: chip.llamaOk ? Theme.fg : Theme.warn
        onClicked: pop.visible = !pop.visible
    }

    Process {
        id: llamaProc
        command: ["curl", "-sS", "-m", "2", "http://127.0.0.1:8081/v1/models"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var obj = JSON.parse(this.text.trim());
                    var models = obj.models || obj.data || [];
                    chip.llamaOk = models.length > 0;
                    chip.llamaModel = models.length ? (models[0].name || models[0].id || "model") : "none";
                } catch (e) {
                    chip.llamaOk = false;
                    chip.llamaModel = "offline";
                }
            }
        }
    }

    Process {
        id: grokProc
        command: ["/home/warpuppy/.local/bin/tf-bar-grok"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var obj = JSON.parse(this.text.trim());
                    var pct = obj.pct === null || obj.pct === undefined ? -1 : obj.pct;
                    chip.grokPct = pct >= 0 ? (pct + "%") : "?";
                    chip.grokPctInt = pct;
                } catch (e) {
                    chip.grokPct = "?";
                    chip.grokPctInt = -1;
                }
            }
        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: chip.refresh()
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
                title: "Local AI"
                status: chip.llamaOk ? "LLAMA UP  " + chip.llamaModel : "LLAMA DOWN  local tier"
                big: chip.llamaOk ? "UP" : "DOWN"
            }
            Rectangle {
                width: parent.width
                height: 8
                color: "#222"
                Rectangle {
                    width: parent.width * Math.min(1, Math.max(0, chip.grokPctInt) / 100)
                    height: parent.height
                    color: chip.grokPctInt >= 80 ? Theme.crit : (chip.grokPctInt >= 70 ? Theme.warn : Theme.accent)
                }
            }
            SectionLabel {
                title: "T1 (LLAMA)"
            }
            StatRow {
                label: "Model"
                value: chip.llamaModel
            }
            StatRow {
                label: "Endpoint"
                value: "127.0.0.1:8081/v1/models"
            }
            StatRow {
                label: "Status"
                value: chip.llamaOk ? "ready" : "offline"
            }
            SectionLabel {
                title: "GROK (SUPERGROK)"
            }
            StatRow {
                label: "Weekly pool"
                value: chip.grokPct
            }
            StatRow {
                label: "Source"
                value: "~/.local/bin/tf-bar-grok"
            }
            Text {
                text: "open Grok"
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: Theme.size
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: openGrok.running = true
                }
            }
            Text {
                text: "restart local AI"
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: Theme.size
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: restartLlama.running = true
                }
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: "Local T1 is primary. Metadata, credentials and external links arrive when wired."
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
        }
    }

    Process {
        id: openGrok
        command: ["brave", "https://grok.com/"]
        running: false
    }

    Process {
        id: restartLlama
        command: ["bash", "-lc", "systemctl --user restart vulkan-llama.service 2>/dev/null || true"]
        running: false
    }
}