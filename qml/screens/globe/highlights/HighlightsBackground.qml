import QtQuick 2.6
import QtGraphicalEffects 1.0

import com.dev.themes.singletons 1.0

Rectangle {
    id: root

    readonly property color borderColor: "#FF1C1B1C"
    property real backgroundRadius: Dimen._32

    color: "#80000000"
    layer {
        effect: OpacityMask {
            maskSource: mask

            Item {
                id: mask

                anchors.fill: parent
                visible: false

                Rectangle {
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        top: parent.top
                        bottomMargin: -radius
                    }
                    width: 0.5 * parent.width
                    radius: backgroundRadius
                }
                Rectangle {
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        top: parent.top
                        leftMargin: -radius
                    }
                    width: 0.5 * parent.width + 2 * radius
                    radius: backgroundRadius
                }
            }
        }
        enabled: true
    }

    Rectangle {
        id: highlightBackgroundTopBorder

        anchors {
            fill: parent
            bottomMargin: -radius
        }
        color: "transparent"
        border {
            color: borderColor
            width: Dimen._1
        }
        radius: backgroundRadius
    }
    Rectangle {
        id: highlightBackgroundRightBottomBorder

        anchors {
            fill: parent
            leftMargin: -radius
            topMargin: -radius
        }
        color: "transparent"
        border {
            color: highlightBackgroundTopBorder.border.color
            width: highlightBackgroundTopBorder.border.width
        }
        radius: backgroundRadius
    }
}
