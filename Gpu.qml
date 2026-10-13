import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: chip
    required property var barWindow
    property string label: "gpu ?"
    property string cls: ""
    property color textColor: Theme.fg
    property var d: ({})

    implicitWidth: btn.implicitWidth
    implicitHeight: Theme.barH

    BarChip {
        id: btn
        anchors.fill: parent
        label: chip.label
        labelColor: chip.textColor
        onClicked: pop.visible = !pop.visible
    }

    Process {
        id: proc
        command: ["/home/warpuppy/.local/bin/waybar-gpu"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var obj = JSON.parse(this.text.trim());
                    chip.d = obj;
                    chip.label = obj.text || chip.label;
                    chip.cls = obj.class || "";
                    if (chip.cls === "warn")
                        chip.textColor = Theme.warn;
                    else if (chip.cls === "critical")
                        chip.textColor = Theme.crit;
                    else
                        chip.textColor = Theme.fg;
                } catch (e) {}
            }
        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: proc.running = true
    }

    function v(key, suffix) {
        var x = chip.d[key];
        if (x === undefined || x === null || x === "")
            return "?";
        return suffix ? (x + suffix) : ("" + x);
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
                title: chip.v("name")
                status: "POLARIS  BUS 0A"
                big: chip.v("busy", "%")
            }
            SectionLabel {
                title: "THERMAL"
            }
            StatRow {
                label: "Temperature"
                value: chip.v("temp", "°C")
            }
            StatRow {
                label: "Fan"
                value: chip.v("fan", " RPM")
            }
            StatRow {
                label: "Power"
                value: chip.v("power", " W")
            }
            SectionLabel {
                title: "MEMORY"
            }
            StatRow {
                label: "VRAM"
                value: chip.v("vram", "%") + (chip.d.vram_mb ? "  " + chip.d.vram_mb + " MB" : "")
            }
            StatRow {
                label: "GTT"
                value: chip.v("gtt", "%")
            }
            SectionLabel {
                title: "CLOCKS"
            }
            StatRow {
                label: "Shader"
                value: chip.v("sclk")
            }
            StatRow {
                label: "Memory"
                value: chip.v("mclk")
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: "RX 480 status is published by waybar-gpu. Some sensors may be unavailable."
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
        }
    }
}
