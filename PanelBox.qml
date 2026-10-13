import QtQuick

Rectangle {
    id: root
    default property alias content: col.data
    color: Theme.panelBg
    border.color: Theme.panelBorder
    border.width: 1
    implicitWidth: Theme.panelW
    implicitHeight: col.implicitHeight + Theme.panelPad * 2

    Column {
        id: col
        x: Theme.panelPad
        y: Theme.panelPad
        width: parent.width - Theme.panelPad * 2
        spacing: 14
    }
}
