import QtQuick

Item {
    id: root
    property string label: ""
    property color labelColor: Theme.fg
    signal clicked

    implicitWidth: txt.implicitWidth
    implicitHeight: Theme.barH

    Text {
        id: txt
        anchors.verticalCenter: parent.verticalCenter
        leftPadding: Theme.pad
        rightPadding: Theme.pad
        text: root.label
        color: root.labelColor
        font.family: Theme.font
        font.pixelSize: Theme.size
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
