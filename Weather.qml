import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: chip
    required property var barWindow
    property bool ok: false
    property string location: "—"
    property string condition: "—"
    property string temp: "?"
    property string humidity: "?"
    property string wind: "?"
    property var forecast: []
    property string updated: "—"

    implicitWidth: btn.implicitWidth
    implicitHeight: Theme.barH

    function refresh() {
        weatherProc.running = true
    }

    BarChip {
        id: btn
        anchors.fill: parent
        label: chip.ok ? ("weather " + chip.temp + "°") : "weather ?"
        labelColor: chip.ok ? Theme.fg : Theme.warn
        onClicked: pop.visible = !pop.visible
    }

    Process {
        id: weatherProc
        command: ["curl", "-sS", "-m", "8", "https://wttr.in/?format=j1"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var obj = JSON.parse(this.text.trim());
                    var area = (obj.nearest_area && obj.nearest_area[0]) || {};
                    var areaName = (area.areaName && area.areaName[0] && area.areaName[0].value) || "Unknown";
                    var regionName = (area.region && area.region[0] && area.region[0].value) || "";
                    chip.location = regionName.length ? (areaName + ", " + regionName) : areaName;
                    var cur = (obj.current_condition && obj.current_condition[0]) || {};
                    chip.temp = cur.temp_C !== undefined ? (cur.temp_C + "°C") : "?";
                    var desc = (cur.weatherDesc && cur.weatherDesc[0] && cur.weatherDesc[0].value) || "—";
                    chip.condition = desc;
                    chip.humidity = cur.humidity !== undefined ? (cur.humidity + "%") : "?";
                    chip.wind = cur.windspeedKmph !== undefined ? (cur.windspeedKmph + " km/h") : "?";
                    chip.updated = new Date().toLocaleTimeString();
                    var days = obj.weather || [];
                    var out = [];
                    for (var i = 0; i < Math.min(days.length, 3); i++) {
                        var d = days[i];
                        var dday = d.date || "";
                        var label = dday;
                        try {
                            var dt = new Date(dday + "T00:00:00");
                            label = dt.toLocaleDateString("en-ZA", { weekday: "short", day: "2-digit", month: "short" });
                        } catch (e) {}
                        var maxv = d.maxtempC !== undefined ? d.maxtempC : "?";
                        var minv = d.mintempC !== undefined ? d.mintempC : "?";
                        var tdesc = (d.weatherDesc && d.weatherDesc[0] && d.weatherDesc[0].value) || "—";
                        out.push({ label: label, value: (minv + "/" + maxv + "  " + tdesc) });
                    }
                    chip.forecast = out;
                    chip.ok = true;
                } catch (e) {
                    chip.ok = false;
                    chip.condition = "offline";
                }
            }
        }
    }

    Timer {
        interval: 900000
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
                title: "Weather"
                status:chip.location.toUpperCase()
                big: chip.temp
            }
            SectionLabel {
                title: "CURRENT"
            }
            StatRow {
                label: "Condition"
                value: chip.condition
            }
            StatRow {
                label: "Humidity"
                value: chip.humidity
            }
            StatRow {
                label: "Wind"
                value: chip.wind
            }
            StatRow {
                label: "Updated"
                value: chip.updated
            }
            SectionLabel {
                title: "NEXT 3 DAYS"
            }
            Repeater {
                model: chip.forecast
                StatRow {
                    required property var modelData
                    label: modelData.label
                    value: modelData.value
                }
            }
            Text {
                text: "refresh"
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: Theme.size
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: chip.refresh()
                }
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: "Location resolved automatically from IP. No credentials or central key required."
                color: Theme.dim
                font.family: Theme.font
                font.pixelSize: Theme.captionSize
            }
        }
    }
}