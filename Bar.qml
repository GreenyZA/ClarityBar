import Quickshell
import QtQuick
import QtQuick.Layouts

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: barWin
        required property var modelData
        screen: modelData

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: Theme.barH
        color: Theme.bg
        exclusiveZone: Theme.barH

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Chip {
                label: "tf"
                color: Theme.accent
            }

            Workspaces {
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            }

            Clock {
                barWindow: barWin
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.preferredWidth: Theme.pad * 3
                Layout.preferredHeight: Theme.barH
            }

            Weather {
                barWindow: barWin
            }

            Item {
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                spacing: 0

                Notes {
                    barWindow: barWin
                }
                AiStatus {
                    barWindow: barWin
                }
                Voice {
                    barWindow: barWin
                }
                Vol {
                    barWindow: barWin
                }
                Net {
                    barWindow: barWin
                }
                Mem {
                    barWindow: barWin
                }
                Gpu {
                    barWindow: barWin
                }
                Cpu {
                    barWindow: barWin
                }
                Anvil {
                    barWindow: barWin
                }
            }
        }
    }
}
