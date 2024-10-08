import QtQuick 2.6

import com.dev.themes.controls 1.0
import com.dev.themes.singletons 1.0

Item {
    id: root

    readonly property alias background: background
    readonly property alias closeButton: closeButton
    readonly property alias touchFilterArea: touchFilterArea

    MultiPointTouchArea {
        id: touchFilterArea

        anchors.fill: background
    }
    Rectangle {
        id: background

        anchors.fill: parent
        gradient: ThemeConstants.colors.primaryGradient
    }
    CommonButton {
        id: closeButton

        anchors {
            right: parent.right
            top: parent.top
            margins: Dimen._20
        }
        width: Dimen._60
        height: width
        z: 1
        icon.source: "qrc:///qml/screens/globe/images/close.png"

        CommonButtonStateGroup {
            button: closeButton
            normalIconColor: ThemeConstants.colors.primaryColor
        }
    }
}
