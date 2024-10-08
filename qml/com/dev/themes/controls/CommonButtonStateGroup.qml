import QtQuick 2.6

import com.dev.apps 1.1

StateGroup {
    id: root

    property color focusFrameColor: "white"
    property color pressedBackgroundColor: normalBackgroundColor
    property color pressedIconColor: "white"
    property color checkedBackgroundColor: normalBackgroundColor
    property color checkedIconColor: normalIconColor
    property color normalBackgroundColor: "transparent"
    property color normalIconColor: "black"
    property CommonButton button

    state: "normal"
    states: [
        State {
            name: "disabled and focused"
            when: !button.enabled
                  && button.activeFocus
            extend: "disabled"

            PropertyChanges {
                target: button
                background.border.color: root.focusFrameColor
            }
        },
        State {
            name: "disabled and checked"
            when: !button.enabled
                  && button.effectiveChecked
            extend: "checked"

            PropertyChanges {
                target: button
                icon.opacity: 0.5
            }
        },
        State {
            name: "disabled"
            when: !button.enabled
            extend: "normal"

            PropertyChanges {
                target: button
                icon.opacity: 0.5
                background.border.color: "transparent"
            }
        },
        State {
            name: "checked and key pressed"
            when: button.effectiveChecked
                  && button.activeFocus
                  && button.Navigation.pressed
            extend: "checked"

            PropertyChanges {
                target: button
                background.border.color: root.focusFrameColor
            }
        },
        State {
            name: "key pressed"
            when: button.activeFocus
                  && button.Navigation.pressed
            extend: "pressed"

            PropertyChanges {
                target: button
                background.border.color: root.focusFrameColor
            }
        },
        State {
            name: "checked and pressed"
            when: button.effectiveChecked
                  && button.pressed
            extend: "pressed"

            PropertyChanges {
                target: button
                icon.color: root.pressedIconColor
            }
        },
        State {
            name: "checked and focused"
            when: button.effectiveChecked
                  && button.activeFocus
            extend: "checked"

            PropertyChanges {
                target: button
                background.border.color: root.focusFrameColor
            }
        },
        State {
            name: "focused"
            when: button.activeFocus
            extend: "normal"

            PropertyChanges {
                target: button
                background.border.color: root.focusFrameColor
            }
        },
        State {
            name: "pressed"
            when: button.pressed
            extend: "normal"

            PropertyChanges {
                target: button
                background.color: root.pressedBackgroundColor
                icon.color: root.pressedIconColor
            }
        },
        State {
            name: "checked"
            when: button.effectiveChecked
            extend: "normal"

            PropertyChanges {
                target: button
                background.color: root.checkedBackgroundColor
                icon.color: root.checkedIconColor
            }
        },
        State {
            name: "normal"
            when: !button.effectiveChecked
                  && !button.pressed
                  && !button.activeFocus
                  && !button.Navigation.pressed

            PropertyChanges {
                target: button
                background.border.color: "transparent"
                background.color: root.normalBackgroundColor
                icon.color: root.normalIconColor
            }
        }
    ]
}
