import QtQuick

Item {
    id: root
    property string title: ""
    property string status: ""
    property string big: ""
    width: parent ? parent.width : Theme.panelW
    implicitHeight: Math.max(titleCol.implicitHeight, bigTxt.implicitHeight)

    Column {
        id: titleCol
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: bigTxt.left
        anchors.rightMargin: 10
        spacing: 2

        Text {
            text: root.title
            color: Theme.fg
            font.family: Theme.font
            font.pixelSize: Theme.titleSize
            elide: Text.ElideRight
            width: parent.width
        }

        Text {
            text: root.status
            color: Theme.dim
            font.family: Theme.font
            font.pixelSize: Theme.captionSize
            elide: Text.ElideRight
            width: parent.width
        }
    }

    Text {
        id: bigTxt
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: root.big
        color: Theme.fg
        font.family: Theme.font
        font.pixelSize: Theme.displaySize
    }
}
