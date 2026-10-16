import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: chip
    required property var barWindow
    property bool llamaOk: false
    property string llamaModel: "none"
    property bool gamingMode: false

    implicitWidth: btn.implicitWidth
    implicitHeight: Theme.barH

    function refresh() {
        llamaProc.running = true
    }

    function toggleGaming() {
        gamingMode = !gamingMode
        gameProc.command = gamingMode
            ? ["ssh", "acer", "systemctl --user stop llama-vulkan.service; sudo systemctl stop ollama.service"]
            : ["ssh", "acer", "systemctl --user restart llama-vulkan.service; sudo systemctl start ollama.service"]
        gameProc.running = true
    }

    BarChip {
        id: btn
        anchors.fill: parent
        label: chip.gamingMode ? "gaming" : (chip.llamaOk ? "ai up" : "ai ?")
        labelColor: chip.gamingMode ? Theme.crit : (chip.llamaOk ? "#66cc66" : Theme.warn)
        onClicked: pop.visible = !pop.visible
    }

    Process {
        id: llamaProc
        command: ["curl", "-sS", "-m", "2", "http://192.168.1.10:8081/v1/models"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var obj = JSON.parse(this.text.trim());
                    var models = obj.models || obj.data || [];
                    chip.llamaOk = models.length > 0;
                    chip.llamaModel = models.length ? (models[0].name || models[0].id || "model") : "none";
                    chip.gamingMode = !chip.llamaOk;
                } catch (e) {
                    chip.llamaOk = false;
                    chip.llamaModel = "offline";
                    chip.gamingMode = true;
                }
            }
        }
    }

    Process {
        id: gameProc
        command: ["true"]
        running: false
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
            SectionLabel {
                title: "T1 (LLAMA)"
            }
            StatRow {
                label: "Model"
                value: chip.llamaModel
            }
            StatRow {
                label: "Endpoint"
                value: "192.168.1.10:8081/v1/models"
            }
            StatRow {
                label: "Status"
                value: chip.llamaOk ? "ready" : "offline"
            }
            SectionLabel {
                title: "GAMING MODE"
            }
            StatRow {
                label: "Mode"
                value: chip.gamingMode ? "gaming / AI off" : "AI / normal"
            }
            Text {
                text: chip.gamingMode ? "disable gaming mode" : "enable gaming mode"
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: Theme.size
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: chip.toggleGaming()
                }
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: "Gaming mode stops local LLM services on Acer to free VRAM; disable it to restore AI."
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
        }
    }
}