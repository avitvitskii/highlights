import QtQuick 2.6

import com.dev.apps 1.1
import com.dev.map3d 1.1

MouseArea {
    id: root

    /*! This property holds control holded state. Holded state starts when Enter-like key pressed and stops on release. */
    property bool holded: false
    /*! This property holds whether holds state can be activated. Default value is false. */
    property bool enableHolded: false
    property bool clickOnRelease: true

    property bool checked: false
    property bool checkable: false
    readonly property alias effectiveChecked: root.__effectiveChecked // @disable-check M402
    property bool __effectiveChecked: false

    signal enterPressed()

    function switchCheckedState() {
        __effectiveChecked = !__effectiveChecked;
    }

    onCheckedChanged: if (effectiveChecked !== checked) __effectiveChecked = checked
    onClicked: {
        if (checkable) {
            switchCheckedState();
        }
    }
    Navigation.onPressedChanged: {
        if (!enabled) {
            return;
        }

        if (Navigation.pressed) {
            if (enableHolded) {
                pressAndHold.start();
            }
            if (!clickOnRelease || enableHolded) {
                root.clicked(undefined);
            }
            root.enterPressed();
        } else {
            if( pressAndHold.running ) {
                pressAndHold.stop();
            } else {
                if (clickOnRelease) {
                    root.clicked(undefined);
                }
            }
            holded = false;
        }
    }
    Keys.onReleased: {
        switch (event.key) {
            case Qt.Key_Enter:
                if( pressAndHold.running ) {
                    pressAndHold.stop();
                }
            case Qt.Key_Return:
                holded = false;
                event.accepted = true;
                break;
            default:
                break;
        }
    }
    onActiveFocusChanged: {
        //hold enter and move focus: you dont get release event.
        if( !activeFocus )
        {
            if( pressAndHold.running ) {
                pressAndHold.stop();
            }
            if( holded ) {
                holded = false;
            }
        }
    }

    Timer {
        id: pressAndHold

        interval: root.Navigation.pressed && root.enableHolded ? 100 : 300
        running: (root.pressed || root.Navigation.pressed) && root.enableHolded
        repeat: true
        onTriggered: root.clicked(undefined)
    }
}
