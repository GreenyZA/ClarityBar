import QtQuick

Text {
    id: root
    signal clicked

    property string label: ""
    text: label
    leftPadding: Theme.pad
    rightPadding: Theme.pad
    font.family: Theme.font
    font.pixelSize: Theme.size
    color: Theme.fg
    verticalAlignment: Text.AlignVCenter

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
