import QtQuick 2.6

import com.dev.themes.controls 1.0
import com.dev.themes.singletons 1.0

Item {
    id: root

    readonly property bool ready: highlightsStore.configured

    property real fullHeight: 0
    readonly property alias buttonClose: buttonClose
    readonly property alias buttonFeed: buttonFeed
    readonly property alias itemLayout: itemLayout
    readonly property alias listView: listView
    readonly property alias mouseAreaSwipeDetector: mouseAreaSwipeDetector
    readonly property alias preloader: preloader
    readonly property alias scrollBar: scrollBar
    property bool isOpened: ready // only initial
    property bool isWhole: false

    Item {
        id: itemLayout

        anchors {
            fill: parent
            margins: Dimen._24
        }

        ListView {
            id: listView

            anchors {
                fill: parent
                bottomMargin: preloader.visible ? Dimen._50 : 0
            }
            spacing: Dimen._8
            verticalLayoutDirection: ListView.BottomToTop
            Component.onCompleted: listView.positionViewAtBeginning()
        }
        HighlightsBackground {
            id: preloader

            anchors.bottom: parent.bottom
            width: Dimen._96
            height: Dimen._36
            backgroundRadius: Dimen._16
            visible: false

            Row {
                anchors.centerIn: parent
                spacing: Dimen._8

                Repeater {
                    model: 3

                    Rectangle {
                        width: Dimen._16
                        height: width
                        radius: 0.5 * width
                        color: "white"
                        opacity: 0.2

                        SequentialAnimation on opacity {
                            id: animation

                            running: preloader.visible

                            PauseAnimation {
                                duration: index * 250
                            }
                            OpacityAnimator {
                                duration: 200
                                from: 0.2
                                to: 1.0
                            }
                            PauseAnimation {
                                duration: 100
                            }
                            OpacityAnimator {
                                duration: 200
                                from: 1.0
                                to: 0.2
                            }
                            PauseAnimation {
                                duration: 100
                            }
                            ScriptAction {
                                script: if (index === 2) preloader.visible = false
                            }
                        }
                    }
                }
            }
        }
    }
    ScrollBar {
        id: scrollBar

        anchors {
            bottom: parent.bottom
            right: parent.right
            top: parent.top
        }
        width: Dimen._20
        flickable: listView
        orientation: Qt.Vertical
        slider {
            handle: Item {
                width: scrollBar.slider.width
                height: scrollBar.slider.height * listView.visibleArea.heightRatio

                Rectangle {
                    anchors {
                        bottom: parent.bottom
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                    width: Dimen._5
                    color: ThemeConstants.colors.primaryColor
                    radius: Number.MAX_VALUE
                }
            }
        }
    }
    MouseArea {
        id: mouseAreaSwipeDetector

        property real startX
        property real startY

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        propagateComposedEvents: true
        onPressed: {
            startX = mouseX;
            startY = mouseY;
        }
        onReleased: {
            var deltaX = mouseX - startX;
            var deltaY = mouseY - startY;

            if (deltaY < -20 && Math.abs(deltaY) > Math.abs(deltaX)) {
                isWhole = true;
                return;
            }
            if (deltaY > 20 && Math.abs(deltaY) > Math.abs(deltaX)) {
                isOpened = false;
            }
        }
    }
    CommonButton {
        id: buttonClose

        anchors {
            right: parent.right
            top: parent.top
            margins: Dimen._20
        }
        width: Dimen._60
        height: width
        z: 1
        icon.source: "qrc:///qml/screens/globe/images/close.png"
    }
    CommonButton {
        id: buttonFeed

        anchors {
            bottom: parent.bottom
            left: parent.left
            margins: Dimen._20
        }
        background.radius: Number.MAX_VALUE
        width: Dimen._60
        height: width
        checkable: true
        z: 1
        icon.source: "qrc:///qml/screens/globe/highlights/images/message.png"
    }
    CommonButtonStateGroup {
        button: buttonFeed
        normalBackgroundColor: "#80000000"
        normalIconColor: "transparent"
    }

    state: "close"
    states: [
        State {
            name: "close"
            when: !isOpened

            PropertyChanges {
                target: listView
                interactive: false
            }
            PropertyChanges {
                target: preloader
                visible: false
            }
            PropertyChanges {
                target: scrollBar
                visible: false
            }
            PropertyChanges {
                target: mouseAreaSwipeDetector
                enabled: false
            }
            PropertyChanges {
                target: root
                implicitHeight: Dimen._80
            }
        },
        State {
            name: "whole open"
            when: isOpened && isWhole

            PropertyChanges {
                target: listView
                interactive: true
            }
            PropertyChanges {
                target: scrollBar
                visible: listView.visibleArea.heightRatio < 1
            }
            PropertyChanges {
                target: mouseAreaSwipeDetector
                enabled: false
            }
            PropertyChanges {
                target: root
                implicitHeight: fullHeight
            }
        },
        State {
            name: "open"
            when: isOpened

            PropertyChanges {
                target: listView
                interactive: false
            }
            PropertyChanges {
                target: scrollBar
                visible: false
            }
            PropertyChanges {
                target: mouseAreaSwipeDetector
                enabled: true
            }
            PropertyChanges {
                target: root
                implicitHeight: Dimen._230
            }
            StateChangeScript {
                name: "positionViewAtBeginning"
                script: listView.positionViewAtBeginning()
            }
        }
    ]
}
