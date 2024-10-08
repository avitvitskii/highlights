import QtQuick 2.6

import com.dev.apps 1.1

Item {
    id: root

    readonly property alias loaderHandle: loaderHandle
    readonly property alias loaderGroove: loaderGroove

    property bool asynchronous: false
    property real maximumValue: 1.0
    property real minimumValue: 0.0
    property real value: 0.0
    property real stepSize: 0.0
    property int orientation: Qt.Horizontal

    property bool dragEnabled: true
    property alias handleVisibility: loaderHandle.visible
    property alias grooveVisibility: loaderGroove.visible

    property alias handle: loaderHandle.sourceComponent
    property alias groove: loaderGroove.sourceComponent

    signal canceled()
    signal clicked(var mouse)
    signal pressAndHold(var mouse)
    signal pressed(var mouse)
    signal released(var mouse)

    implicitWidth: Math.max(loaderGroove.implicitWidth,
                            loaderHandle.implicitWidth)
    implicitHeight: Math.max(loaderGroove.implicitHeight,
                             loaderHandle.implicitHeight)
    onMaximumValueChanged: Qt.callLater(presenter.updateMaximumValue)
    onMinimumValueChanged: Qt.callLater(presenter.updateMinimumValue)
    Component.onCompleted: value = presenter.minimumValue

    QtObject {
        id: presenter

        property real dragMaximum: 0.0
        property real maximumValue: 1.0
        property real minimumValue: 0.0
        /*!
          left side's position of the handle based on 'value' property of the root
        */
        property real handlePosition: 0
        /*!
          relative value (in [0.0, 1.0]) based on position of the handle
        */
        property real handleValue: 0.0
        readonly property real relativeValue: (Math.max(value, minimumValue) - minimumValue) / valueInterval
        readonly property real valueInterval: maximumValue - minimumValue

        function updateDragMaximum(prop) {
            dragMaximum = root[prop] - loaderHandle[prop];
        }
        function updateMaximumValue() {
            maximumValue = root.maximumValue;
        }
        function updateMinimumValue() {
            minimumValue = root.minimumValue;
        }
    }
    QtObject {
        id: objectStyleData

        readonly property int handlePosition: {
            switch (root.orientation) {
                case Qt.Horizontal:
                    return loaderHandle.x + 0.5 * loaderHandle.width;
                case Qt.Vertical:
                    return loaderHandle.y + 0.5 * loaderHandle.height;
                default:
                    return 0;
            }
        }
    }
    Loader {
        id: loaderGroove

        readonly property alias styleData: objectStyleData

        asynchronous: root.asynchronous
    }
    Loader {
        id: loaderHandle

        readonly property alias styleData: objectStyleData

        asynchronous: root.asynchronous
    }
    MouseArea {
        id: mouseAreaHandle

        width: loaderHandle.width
        height: loaderHandle.height
        drag.target: root.dragEnabled ? mouseAreaHandle : null
        enabled: root.enabled
        onCanceled: root.canceled()
        onClicked: root.clicked(mouse)
        onPressAndHold: root.pressAndHold(mouse)
        onPressed: root.pressed(mouse)
        onReleased: root.released(mouse)
    }
    Binding {
        when: mouseAreaHandle.drag.active
        target: root
        property: "value"
        value: presenter.minimumValue
               + (stepSize <= 0
                  ? presenter.valueInterval * presenter.handleValue
                  : Math.round(presenter.handleValue * presenter.valueInterval / stepSize) * stepSize)
    }
    Binding {
        target: loaderHandle
        property: {
            switch (orientation) {
                case Qt.Horizontal:
                    return 'x';
                case Qt.Vertical:
                    return 'y';
                default:
                    console.error("Invalid 'orientaion' value.");
            }
        }
        value: presenter.handlePosition
    }
    Binding {
        when: !mouseAreaHandle.drag.active
        target: mouseAreaHandle
        property: {
            switch (orientation) {
                case Qt.Horizontal:
                    return 'x';
                case Qt.Vertical:
                    return 'y';
                default:
                    console.error("Invalid 'orientaion' value.");
            }
        }
        value: presenter.handlePosition
    }

    states: [
        State {
            name: 'horizontal'
            when: root.orientation === Qt.Horizontal

            AnchorChanges {
                target: loaderGroove
                anchors {
                    left: root.left
                    right: root.right
                    verticalCenter: root.verticalCenter
                }
            }
            AnchorChanges {
                target: loaderHandle
                anchors.verticalCenter: root.verticalCenter
            }
            PropertyChanges {
                target: presenter
                handlePosition: App.layoutDirection === Qt.RightToLeft
                                ? (1 - relativeValue) * (mouseAreaHandle.drag.maximumX - mouseAreaHandle.drag.minimumX)
                                : relativeValue * (mouseAreaHandle.drag.maximumX - mouseAreaHandle.drag.minimumX)
                handleValue: App.layoutDirection === Qt.RightToLeft
                             ? (mouseAreaHandle.drag.maximumX - mouseAreaHandle.x) / (mouseAreaHandle.drag.maximumX - mouseAreaHandle.drag.minimumX)
                             : mouseAreaHandle.x / (mouseAreaHandle.drag.maximumX - mouseAreaHandle.drag.minimumX)
            }
            PropertyChanges {
                target: mouseAreaHandle
                drag {
                    axis: Drag.XAxis
                    maximumX: presenter.dragMaximum
                    minimumX: 0
                }
                y: loaderHandle.y
            }
            PropertyChanges {
                target: root
                onWidthChanged: Qt.callLater(presenter.updateDragMaximum, "width")
            }
            PropertyChanges {
                target: loaderHandle
                onWidthChanged: Qt.callLater(presenter.updateDragMaximum, "width")
            }
        },
        State {
            name: 'vertical'
            when: root.orientation === Qt.Vertical

            AnchorChanges {
                target: loaderGroove
                anchors {
                    bottom: root.bottom
                    top: root.top
                    horizontalCenter: root.horizontalCenter
                }
            }
            AnchorChanges {
                target: loaderHandle
                anchors.horizontalCenter: root.horizontalCenter
            }
            PropertyChanges {
                target: presenter
                handlePosition: relativeValue * (mouseAreaHandle.drag.maximumY - mouseAreaHandle.drag.minimumY)
                handleValue: mouseAreaHandle.y / (mouseAreaHandle.drag.maximumY - mouseAreaHandle.drag.minimumY)
            }
            PropertyChanges {
                target: mouseAreaHandle
                drag {
                    axis: Drag.YAxis
                    maximumY: presenter.dragMaximum
                    minimumY: 0
                }
                x: loaderHandle.x
            }
            PropertyChanges {
                target: root
                onHeightChanged: Qt.callLater(presenter.updateDragMaximum, "height")
            }
            PropertyChanges {
                target: loaderHandle
                onHeightChanged: Qt.callLater(presenter.updateDragMaximum, "height")
            }
        }
    ]
}
