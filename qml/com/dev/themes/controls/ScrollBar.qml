import QtQuick 2.6
import QtQuick.Layouts 1.3

import com.dev.apps 1.1

GridLayout {
    id: root

    property Flickable flickable
    property alias orientation: slider.orientation
    property real step
    readonly property alias buttonNext: buttonNext
    readonly property alias buttonPrevious: buttonPrevious
    readonly property alias slider: slider
    property bool __inUse: false

    function setSliderPosition(value) {
        __inUse = true;
        slider.value = value;
        __inUse = false;
    }

    columnSpacing: 0
    rowSpacing: 0

    CommonButton {
        id: buttonPrevious

        onClicked: setSliderPosition(Math.max(slider.value - step, slider.minimumValue))

        Navigation {
            id: navigationButtonPrevious

            target: buttonPrevious
        }
    }
    Slider {
        id: slider

        enabled: !!flickable
        onPressed: __inUse = true
        onReleased: __inUse = false
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
    CommonButton {
        id: buttonNext

        onClicked: setSliderPosition(Math.min(slider.value + step, slider.maximumValue))

        Navigation {
            id: navigationButtonNext

            target: buttonNext
        }
    }
    StateGroup {
        states: [
            State {
                name: "no flickable"
                when: !flickable

                PropertyChanges {
                    target: root
                    visible: false
                }
            },
            State {
                name: "horizontal"
                when: orientation === Qt.Horizontal

                PropertyChanges {
                    target: root
                    step: flickable.visibleArea.widthRatio
                    columns: 3
                    rows: 1
                }
                PropertyChanges {
                    target: buttonNext
                    enabled: !flickable.atXEnd
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                }
                PropertyChanges {
                    target: buttonPrevious
                    enabled: !flickable.atXBeginning
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                }
                PropertyChanges {
                    target: navigationButtonNext
                    left: !buttonNext.LayoutMirroring.enabled ? buttonPrevious : null
                    right: buttonNext.LayoutMirroring.enabled ? buttonPrevious : null
                }
                PropertyChanges {
                    target: navigationButtonPrevious
                    left: buttonPrevious.LayoutMirroring.enabled ? buttonNext : null
                    right: !buttonPrevious.LayoutMirroring.enabled ? buttonNext : null
                }
                PropertyChanges {
                    target: slider
                    maximumValue:  1 - visibleArea.widthRatio
                    onValueChanged: {
                        if (__inUse) {
                            flickable.contentX = flickable.originX + slider.value * flickable.contentWidth;
                        }
                    }
                }
                PropertyChanges {
                    target: flickable.visibleArea
                    onXPositionChanged: {
                        if (!__inUse) {
                            slider.value = xPosition;
                        }
                    }
                }
            },
            State {
                name: "vertical"
                when: orientation === Qt.Vertical

                PropertyChanges {
                    target: root
                    step: flickable.visibleArea.heightRatio
                    columns: 1
                    rows: 3
                }
                PropertyChanges {
                    target: buttonNext
                    enabled: !flickable.atYEnd
                    Layout.fillWidth: true
                    Layout.fillHeight: false
                }
                PropertyChanges {
                    target: buttonPrevious
                    enabled: !flickable.atYBeginning
                    Layout.fillWidth: true
                    Layout.fillHeight: false
                }
                PropertyChanges {
                    target: navigationButtonNext
                    up: buttonPrevious
                }
                PropertyChanges {
                    target: navigationButtonPrevious
                    down: buttonNext
                }
                PropertyChanges {
                    target: slider
                    maximumValue: 1 - flickable.visibleArea.heightRatio
                    onValueChanged: {
                        if (__inUse) {
                            flickable.contentY = flickable.originY + slider.value * flickable.contentHeight;
                        }
                    }
                }
                PropertyChanges {
                    target: flickable.visibleArea
                    onYPositionChanged: {
                        if (!__inUse) {
                            slider.value = yPosition;
                        }
                    }
                }
            }
        ]
    }
}
