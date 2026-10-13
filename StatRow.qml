import QtQuick

Row {
    id: root
    property string label: ""
    property string value: ""
    width: parent ? parent.width : Theme.panelW
    spacing: 8

    Text {
        width: Theme.labelW
        text: root.label
        color: Theme.dim
        font.family: Theme.font
        font.pixelSize: Theme.captionSize
        wrapMode: Text.NoWrap
    }

    Text {
        width: parent.width - Theme.labelW - 8
        text: root.value
        color: Theme.fg
        font.family: Theme.font
        font.pixelSize: Theme.size
        wrapMode: Text.Wrap
    }
}
