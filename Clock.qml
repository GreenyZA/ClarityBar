import Quickshell
import QtQuick

Item {
    id: chip
    required property var barWindow
    property date now: new Date()

    implicitWidth: btn.implicitWidth
    implicitHeight: Theme.barH

    BarChip {
        id: btn
        anchors.fill: parent
        label: Qt.formatDateTime(chip.now, "ddd dd MMM  HH:mm")
        onClicked: pop.visible = !pop.visible
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
        onDateChanged: chip.now = clock.date
    }

    function buildCalendar(d) {
        var out = []
        if (!d) return out
        var y = d.getFullYear()
        var m = d.getMonth()
        var first = new Date(y, m, 1)
        var lead = first.getDay()
        var last = new Date(y, m + 1, 0).getDate()
        for (var b = 0; b < lead; b++) {
            out.push({ label: "", today: false })
        }
        for (var day = 1; day <= last; day++) {
            out.push({ label: "" + day, today: (day === d.getDate()) })
        }
        return out
    }

    property var calendarDays: buildCalendar(chip.now)

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
                title: "Time"
                status: Qt.formatDateTime(chip.now, "dddd, MMMM d yyyy")
                big: Qt.formatDateTime(chip.now, "HH:mm")
            }
            SectionLabel {
                title: "CALENDAR"
            }
            Text {
                width: parent.width
                text: Qt.formatDateTime(chip.now, "MMMM yyyy").toUpperCase()
                color: Theme.fg
                font.family: Theme.font
                font.pixelSize: Theme.size
            }
            Row {
                id: headerRow
                spacing: 4
                Repeater {
                    model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                    Text {
                        required property string modelData
                        width: 40
                        horizontalAlignment: Text.AlignHCenter
                        text: modelData
                        color: Theme.dim
                        font.family: Theme.font
                        font.pixelSize: Theme.captionSize
                    }
                }
            }
            Grid {
                columns: 7
                rowSpacing: 4
                columnSpacing: 4
                Repeater {
                    model: chip.calendarDays
                    Rectangle {
                        required property var modelData
                        width: 40
                        height: 28
                        color: modelData.today ? Theme.accent : Theme.panelBg
                        border.color: Theme.panelBorder
                        border.width: 1
                        Text {
                            anchors.centerIn: parent
                            text: modelData.label
                            color: modelData.today ? Theme.bg : Theme.fg
                            font.family: Theme.font
                            font.pixelSize: Theme.captionSize
                        }
                    }
                }
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: "Local system clock. Calendar is derived from it (week runs Sunday → Saturday)."
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
        }
    }
}