import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

Item {
    id: chip
    required property var barWindow
    property string draft: ""
    property string lastNotes: "—"

    implicitWidth: btn.implicitWidth
    implicitHeight: Theme.barH

    BarChip {
        id: btn
        anchors.fill: parent
        label: "notes"
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
                title: "Quick Notes"
                status: "LOCAL VAULT ONLY  00-INBOX"
                big: "NOTE"
            }
            SectionLabel {
                title: "INPUT"
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: "One line per entry → ~/Documents/Clarity/00-Inbox/bar-notes.md"
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
            TextField {
                id: noteField
                width: parent.width
                placeholderText: "Type and press Enter"
                background: Rectangle {
                    color: "#1c1c1c"
                    border.color: Theme.panelBorder
                    border.width: 1
                }
                color: Theme.fg
                font.family: Theme.font
                font.pixelSize: Theme.size
                onAccepted: {
                    if (text.trim().length > 0) {
                        chip.draft = text.trim();
                        noteProc.running = true;
                        text = "";
                    }
                }
            }
            Text {
                text: "append one-line note (Enter)"
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
            SectionLabel {
                title: "SAVED (LAST 8)"
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: chip.lastNotes
                color: Theme.fg
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
            Text {
                text: "refresh"
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: Theme.size
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: tailProc.running = true
                }
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: "No sync, no client PII. Append only. Vault history preserves revisions."
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
        }
    }

    Process {
        id: noteProc
        command: ["/home/warpuppy/.local/bin/clarity-bar-note", "--text", chip.draft]
        running: false
        onExited: tailProc.running = true
    }

    Process {
        id: tailProc
        command: ["tail", "-n", "8", "/home/warpuppy/Documents/Clarity/00-Inbox/bar-notes.md"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                var t = this.text.trim();
                chip.lastNotes = t.length ? t : "—";
            }
        }
    }
}