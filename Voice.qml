import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: chip
    required property var barWindow
    property string pttState: "idle"
    property string pttTooltip: "Voice PTT idle; press Right Ctrl or Menu"
    property string lastTranscript: "—"
    property string historyText: "—"
    property string activeModel: "tiny.en"
    property int activeMic: -1
    property string activeMicName: "—"

    ListModel { id: micModel }

    implicitWidth: btn.implicitWidth
    implicitHeight: Theme.barH

    function refreshState() {
        stateProc.running = true
        lastProc.running = true
        histProc.running = true
    }

    BarChip {
        id: btn
        anchors.fill: parent
        label: "voice " + chip.pttState
        onClicked: pop.visible = !pop.visible
    }

    Process {
        id: stateProc
        command: ["cat", "/tmp/voice-ptt.state"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var obj = JSON.parse(this.text.trim());
                    chip.pttState = obj.class || chip.pttState;
                    chip.pttTooltip = obj.tooltip || chip.pttTooltip;
                } catch (e) {}
            }
        }
    }

    Process {
        id: lastProc
        command: ["cat", "/tmp/voice-ptt-last.txt"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var t = this.text.trim();
                chip.lastTranscript = t.length ? t : "—";
            }
        }
    }

    Process {
        id: histProc
        command: ["tail", "-n", "8", "/tmp/voice-ptt-history.txt"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var t = this.text.trim();
                chip.historyText = t.length ? t : "—";
            }
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: chip.refreshState()
    }

    Process {
        id: modelProc
        command: ["cat", "/home/warpuppy/.config/voice-ptt.json"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var obj = JSON.parse(this.text.trim());
                    if (obj.model_size) chip.activeModel = obj.model_size;
                    if (obj.device !== undefined) chip.activeMic = obj.device;
                } catch (e) {}
            }
        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: modelProc.running = true
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
                title: "Voice PTT"
                status: chip.pttTooltip
                big: chip.pttState.toUpperCase()
            }
            SectionLabel {
                title: "CONTROLS"
            }
            Text {
                text: "restart PTT service"
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: Theme.size
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: restartProc.running = true
                }
            }
            Text {
                text: "open voice-ptt.json"
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: Theme.size
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: cfgProc.running = true
                }
            }
            SectionLabel {
                title: "LAST TRANSCRIPT"
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: chip.lastTranscript
                color: Theme.fg
                font.family: Theme.font
                font.pixelSize: Theme.size
            }
            SectionLabel {
                title: "HISTORY (last 8)"
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: chip.historyText
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
            SectionLabel {
                title: "MODEL / LANGUAGE (quick set)"
            }
            Text {
                text: chip.activeModel === "tiny.en" ? "set model tiny.en  [ACTIVE]" : "set model tiny.en"
                color: chip.activeModel === "tiny.en" ? Theme.fg : Theme.accent
                font.family: Theme.font
                font.pixelSize: Theme.size
                font.bold: chip.activeModel === "tiny.en"
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: setModelTiny.running = true
                }
            }
            Text {
                text: chip.activeModel === "small.en" ? "set model small.en  [ACTIVE]" : "set model small.en"
                color: chip.activeModel === "small.en" ? Theme.fg : Theme.accent
                font.family: Theme.font
                font.pixelSize: Theme.size
                font.bold: chip.activeModel === "small.en"
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: setModelSmall.running = true
                }
            }
            SectionLabel {
                title: "MICROPHONE (pick; restarts PTT)"
            }
            Text {
                text: "active: " + chip.activeMic + "  " + chip.activeMicName
                color: Theme.fg
                font.family: Theme.font
                font.pixelSize: Theme.size
                font.bold: true
            }
            Repeater {
                model: micModel
                delegate: Text {
                    text: (model.index === chip.activeMic ? "● " : "  ") + model.index + ": " + model.name
                    color: model.index === chip.activeMic ? Theme.fg : (model.ok16k ? Theme.accent : Theme.dim)
                    font.family: Theme.font
                    font.pixelSize: Theme.size
                    font.bold: model.index === chip.activeMic
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: model.ok16k ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: { if (model.ok16k) { setMicProc.micIndex = model.index; setMicProc.running = true; } }
                    }
                }
            }
            Text {
                text: "refresh mic list"
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { micProc.running = false; micReloadDelay.start(); }
                }
            }
            SectionLabel {
                title: "FEATURE ROADMAP"
            }
            StatRow { label: "Mic level meter"; value: "live bars during record" }
            StatRow { label: "Output mode"; value: "type vs clipboard" }
            StatRow { label: "Denoise"; value: "VAD + optional filter" }
            StatRow { label: "Languages"; value: "auto / pinned locale" }
            StatRow { label: "Key binding"; value: "Right Ctrl / Menu" }
            StatRow { label: "Input device"; value: "auto-detect / pick" }
        }
    }

    Process {
        id: restartProc
        command: ["systemctl", "--user", "restart", "voice-ptt.service"]
        running: false
    }

    Process {
        id: cfgProc
        command: ["xdg-open", "/home/warpuppy/.config/voice-ptt.json"]
        running: false
    }

    Process {
        id: setModelTiny
        command: ["python3", "-c", "import json,p=__import__('pathlib').Path('/home/warpuppy/.config/voice-ptt.json');d=json.loads(p.read_text());d['model_size']='tiny.en';p.write_text(__import__('json').dumps(d,indent=2))"]
        running: false
        onExited: { chip.activeModel = 'tiny.en'; restartProc.running = true; }
    }

    Process {
        id: setModelSmall
        command: ["python3", "-c", "import json,p=__import__('pathlib').Path('/home/warpuppy/.config/voice-ptt.json');d=json.loads(p.read_text());d['model_size']='small.en';p.write_text(__import__('json').dumps(d,indent=2))"]
        running: false
        onExited: { chip.activeModel = 'small.en'; restartProc.running = true; }
    }

    Process {
        id: micProc
        command: ["/home/warpuppy/.local/share/voice-dictation/.venv/bin/python", "/home/warpuppy/.local/bin/voice-mics.py"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var arr = JSON.parse(this.text.trim());
                    micModel.clear();
                    for (var i = 0; i < arr.length; i++) micModel.append(arr[i]);
                    for (var j = 0; j < arr.length; j++) {
                        if (arr[j].index === chip.activeMic) {
                            chip.activeMicName = arr[j].name;
                        }
                    }
                } catch (e) {}
            }
        }
    }

    Timer {
        id: micReloadDelay
        interval: 100
        repeat: false
        running: false
        onTriggered: micProc.running = true
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: { micProc.running = false; micProc.running = true; }
    }

    Process {
        id: setMicProc
        property int micIndex: -1
        command: ["python3", "-c", "import json,pathlib; p=pathlib.Path('/home/warpuppy/.config/voice-ptt.json'); d=json.loads(p.read_text()); d['device']=" + setMicProc.micIndex + "; p.write_text(__import__('json').dumps(d,indent=2))"]
        running: false
        onExited: { chip.activeMic = setMicProc.micIndex; for (var i=0;i<micModel.count;i++){ if (micModel.get(i).index === chip.activeMic) chip.activeMicName = micModel.get(i).name; } restartProc.running = true; }
    }
}
