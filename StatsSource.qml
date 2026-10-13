pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property int cpuPct: 0
    property int memPct: 0
    property string netIp: ""
    property string anvilLabel: "anvil ?"
    property var cpuDet: ({})
    property var memDet: ({})
    property var netDet: ({})
    property var anvilDet: ({})
    property var cpuCore: []

    function nvl(v, fallback) {
        return (v === undefined || v === null || v === "") ? fallback : v;
    }

    Process {
        id: proc
        command: ["/home/warpuppy/.local/bin/tf-bar-stats"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var obj = JSON.parse(this.text.trim());
                    var d = obj.detail || {};
                    root.cpuPct = obj.cpu || 0;
                    root.memPct = obj.mem || 0;
                    root.netIp = obj.net || "";
                    root.anvilLabel = obj.anvil || "anvil ?";
                    root.cpuDet = d.cpu || {};
                    root.memDet = d.mem || {};
                    root.netDet = d.net || {};
                    root.anvilDet = d.anvil || {};
                    root.cpuCore = (d.cpu && d.cpu.core) ? d.cpu.core : [];
                } catch (e) {}
            }
        }
    }

    Timer {
        interval: 2000
        repeat: true
        running: true
        onTriggered: proc.running = true
    }
}
