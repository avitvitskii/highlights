import QtQuick 2.6

StyledTextItem {
    id: root

    property TextMetrics textMetrics: componentTextMetrics.createObject()

    implicitWidth: textMetrics.tightBoundingRect.width
                   + textText.anchors.leftMargin
                   + textText.anchors.rightMargin
    implicitHeight: textMetrics.tightBoundingRect.height
                    + textText.bottomPadding
                    + textText.topPadding
    textText {
        anchors {
            fill: undefined
            left: textText.parent.left
            right: textText.parent.right
            baseline: textText.parent.baseline
        }
    }

    Component {
        id: componentTextMetrics

        TextMetrics {
            font: textText.font
            text: textText.text
        }
    }

    StateGroup {
        state: style.verticalAlignment
        states: [
            State {
                name: Text.AlignTop

                PropertyChanges {
                    target: root
                    baselineOffset: -textMetrics.tightBoundingRect.y + textText.topPadding
                }
            },
            State {
                name: Text.AlignVCenter

                PropertyChanges {
                    target: root
                    baselineOffset: 0.5 * (height - textMetrics.tightBoundingRect.y)
                }
            },
            State {
                name: Text.AlignBottom

                PropertyChanges {
                    target: root
                    baselineOffset: height - textText.bottomPadding
                }
            }
        ]
    }
}
