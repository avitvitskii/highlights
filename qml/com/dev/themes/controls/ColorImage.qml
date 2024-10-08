import QtQuick 2.6
import QtGraphicalEffects 1.0

import com.dev.apps 1.1
import com.dev.themes.singletons 1.0

Item {
    id: root

    property alias asynchronous: image.asynchronous
    property color color: 'transparent'
    property alias mipmap: image.mipmap
    property alias mirror: image.mirror
    property alias smooth: image.smooth
    property alias source: image.source
    property alias sourceRotation: image.rotation
    property real sourceScale: 1.0
    property alias sourceSize: image.sourceSize
    readonly property alias status: image.status

    implicitWidth: Math.round(image.implicitWidth * sourceScale)
    implicitHeight: Math.round(image.implicitHeight * sourceScale)

    Image {
        id: image

        anchors.fill: parent
        layer.effect: ColorOverlay {
            cached: true
            color: root.color
        }

        state: "original"
        states: [
            State {
                name: "original"
                when: color === Qt.rgba(0, 0, 0, 0)

                PropertyChanges {
                    target: image
                    layer.enabled: false
                    opacity: 1
                }
            },
            State {
                name: "colorized"
                when: color !== Qt.rgba(0, 0, 0, 0)

                PropertyChanges {
                    target: image
                    layer.enabled: true
                    opacity: color.a
                }
            }
        ]
    }
}
