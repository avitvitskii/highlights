import QtQuick 2.6


Item {
    id: root

    property TextStyle style: TextStyle {}
    property alias text: textText.text
    readonly property alias textText: textText

    implicitWidth: textText.implicitWidth
                   + textText.anchors.leftMargin
                   + textText.anchors.rightMargin
    implicitHeight: textText.implicitHeight
    baselineOffset: textText.baselineOffset
    Component.onCompleted: {
        styleChanged.connect(function onStyleChanged() {
            if (!!style) {
                textText.font = style.font;
            }
        });
        // NOTE: yes we need break binding
        textText.font = style.font;
    }

    Text {
        id: textText

        anchors {
            fill: parent
            leftMargin: root.style.paddings.left
            rightMargin: root.style.paddings.right
        }
        color: root.style.color
        font: root.style.font
        horizontalAlignment: root.style.horizontalAlignment
        verticalAlignment: root.style.verticalAlignment
        lineHeight: root.style.lineHeight
        lineHeightMode: root.style.lineHeightMode
        textFormat: Text.PlainText
        bottomPadding: root.style.paddings.bottom
        topPadding: root.style.paddings.top
        wrapMode: root.style.wrapMode
    }
    Connections {
        target: style
        onFontChanged: {
            if (target.defferedFontUpdate && !!text) {
                textText.textChanged.connect(function updateFont() {
                    textText.textChanged.disconnect(updateFont);
                    textText.font = target.font;
                });
            } else {
                textText.font = target.font;
            }
        }
    }
}
