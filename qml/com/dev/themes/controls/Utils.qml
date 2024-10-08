pragma Singleton

import QtQuick 2.6

QtObject {
    id: root

    property Component componentFontMetrics: FontMetrics {}
    property Component componentErrorItem: Rectangle {
        property alias error: textErrorLabel.text

        Component.onCompleted: {
            console.trace();
            console.error(error);
        }

        Text {
            id: textErrorLabel

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            font {
                family: "Monospace"
                pointSize: 28
            }
            fontSizeMode: Text.HorizontalFit
            minimumPointSize: 5
            padding: 25
        }
    }

    function fontMetrics(font) {
        return componentFontMetrics.createObject(null, {
           font: font
        });
    }
}
