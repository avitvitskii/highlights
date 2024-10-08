import QtQuick 2.6

import com.dev.themes.singletons 1.0

AbstractButton {
    id: root

    readonly property alias background: background
    readonly property alias highlight: highlight
    readonly property alias icon: icon
    readonly property alias label: label

    implicitWidth: Math.max(background.implicitWidth, icon.implicitWidth, label.implicitWidth)
    implicitHeight: Math.max(background.implicitHeight, icon.implicitHeight + label.implicitHeight)

    Rectangle {
        id: background

        anchors.fill: parent
        radius: Dimen._8
        border {
            width: 0
            color: "transparent"
        }
        color: "transparent"
    }
    Rectangle {
        id: highlight

        anchors.fill: background
        z: 100
        color: "transparent"
        border {
            color: background.border.color
            width: Dimen._3
        }
        radius: background.radius
    }
    ColorImage {
        id: icon

        anchors.centerIn: parent
        sourceScale: Dimen.scalingFactor

        Behavior on color {
            ColorAnimation {
                duration: ThemeConstants.transitionSpeed
            }
        }
    }
    FontMeasuredTextItem {
        id: label

        anchors {
            baseline: parent.bottom
            horizontalCenter: icon.horizontalCenter
        }
        width: parent.width
        visible: !!text
    }
}
