import QtQuick 2.6

QtObject {
    id: root

    property color color
    property font font
    property int horizontalAlignment: Text.AlignLeft
    property int verticalAlignment: Text.AlignTop
    property bool defferedFontUpdate: false
    property real lineHeight: 1.0
    property int lineHeightMode: Text.ProportionalHeight
    property int wrapMode: Text.NoWrap
    property Paddings paddings: Paddings {}
}
