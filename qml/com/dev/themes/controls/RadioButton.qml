import QtQuick 2.6

import com.dev.apps 1.1
import com.dev.themes.singletons 1.0

AbstractButton {
    id: root

    readonly property alias background: background
    readonly property alias highlight: highlight
    readonly property alias label: label
    readonly property alias icon: icon
    readonly property alias row: row
    property real indicatorSize: Dimen._32
    property color indicatorBackgroundColor: "white"
    property real indicatorBorderWidth: Dimen._2
    property real innerIndicatorSize: Dimen._14

    implicitWidth: Math.max(background.implicitWidth, row.implicitWidth)
    implicitHeight: Math.max(background.implicitHeight, row.implicitHeight)
    checkable: !effectiveChecked

    Rectangle {
        id: background

        implicitHeight: Dimen._40
        anchors.fill: parent
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
    Row {
        id: row

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        width: root.implicitWidth

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: root.indicatorSize
            height: width
            radius: Number.MAX_VALUE
            color: root.indicatorBackgroundColor
            border {
                color: icon.visible ? icon.color : "transparent"
                width: root.indicatorBorderWidth
            }

            Rectangle {
                id: icon

                anchors.centerIn: parent
                width: root.innerIndicatorSize
                height: width
                radius: Number.MAX_VALUE
                visible: root.effectiveChecked
            }
        }
        FontMeasuredTextItem {
            id: label

            anchors.verticalCenter: parent.verticalCenter
            style {
                color: ThemeConstants.colors.primaryTextColor
                font {
                    capitalization: Strings.primaryFontCapitalization
                    family: Strings.primaryFontFamily
                    pixelSize: Dimen._24
                }
                paddings.left: Dimen._14
            }
        }
    }

    StateGroup {
        state: "normal"
        states: [
            State {
                name: "disabled and focused"
                when: !root.enabled
                      && root.activeFocus
                extend: "disabled"

                PropertyChanges {
                    target: root
                    background.border.color: root.focusFrameColor
                }
            },
            State {
                name: "disabled and checked"
                when: !root.enabled
                      && root.effectiveChecked
                extend: "checked"

                PropertyChanges {
                    target: root
                    opacity: 0.5
                }
            },
            State {
                name: "disabled"
                when: !root.enabled
                extend: "normal"

                PropertyChanges {
                    target: root
                    opacity: 0.5
                }
            },
            State {
                name: "checked and key pressed"
                when: root.effectiveChecked
                      && root.activeFocus
                      && root.Navigation.pressed
                extend: "checked"

                PropertyChanges {
                    target: root
                    background.border.color: ThemeConstants.colors.highlightColor
                    label.style.color: ThemeConstants.colors.primaryColor
                }
            },
            State {
                name: "key pressed"
                when: root.activeFocus
                      && root.Navigation.pressed
                extend: "pressed"

                PropertyChanges {
                    target: root
                    background.border.color: ThemeConstants.colors.highlightColor
                }
            },
            State {
                name: "checked and pressed"
                when: root.effectiveChecked
                      && root.pressed
                extend: "pressed"
            },
            State {
                name: "checked and focused"
                when: root.effectiveChecked
                      && root.activeFocus
                extend: "checked"

                PropertyChanges {
                    target: root
                    background.border.color: ThemeConstants.colors.highlightColor
                }
            },
            State {
                name: "focused"
                when: root.activeFocus
                extend: "normal"

                PropertyChanges {
                    target: root
                    background.border.color: ThemeConstants.colors.highlightColor
                }
            },
            State {
                name: "pressed"
                when: root.pressed
                extend: "normal"

                PropertyChanges {
                    target: root
                    label.style.color: ThemeConstants.colors.primaryColor
                }
            },
            State {
                name: "checked"
                when: root.effectiveChecked
                extend: "normal"
            },
            State {
                name: "normal"
                when: !root.effectiveChecked
                      && !root.pressed
                      && !root.activeFocus
                      && !root.Navigation.pressed

                PropertyChanges {
                    target: root
                    background.border.color: "transparent"
                    background.color: "transparent"
                    icon.color: ThemeConstants.colors.primaryColor
                    label.style.color: ThemeConstants.colors.primaryTextColor
                }
            }
        ]
    }
}
