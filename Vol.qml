import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: chip
    required property var barWindow
    property var sink: Pipewire.defaultAudioSink

    implicitWidth: btn.implicitWidth
    implicitHeight: Theme.barH

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    readonly property int volPct: sink && sink.audio ? Math.round(sink.audio.volume * 100) : -1
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
    readonly property string sinkName: {
        if (!sink)
            return "no output";
        return sink.nickname || sink.description || sink.name || "output";
    }

    BarChip {
        id: btn
        anchors.fill: parent
        label: chip.muted ? "vol mute" : (chip.volPct >= 0 ? "vol " + chip.volPct + "%" : "vol ?")
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
                title: "Audio"
                status: (chip.muted ? "MUTED  " : "OUTPUT  ") + chip.sinkName
                big: chip.muted ? "—" : (chip.volPct >= 0 ? chip.volPct + "%" : "?")
            }
            SectionLabel {
                title: "OUTPUT"
            }
            Slider {
                width: parent.width
                from: 0
                to: 1
                value: chip.sink && chip.sink.audio ? chip.sink.audio.volume : 0
                onMoved: {
                    if (chip.sink && chip.sink.audio)
                        chip.sink.audio.volume = value;
                }
            }
            Text {
                text: chip.muted ? "unmute" : "mute"
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: Theme.size
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (chip.sink && chip.sink.audio)
                            chip.sink.audio.muted = !chip.sink.audio.muted;
                    }
                }
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: "Pipewire default sink. Per-app routing lives in pavucontrol."
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
        }
    }
}
