import QtQuick

Text {
    property string title: ""
    text: title
    color: Theme.dim
    font.family: Theme.font
    font.pixelSize: Theme.captionSize
    width: parent ? parent.width : Theme.panelW
}
