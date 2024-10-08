import QtQuick 2.6

import com.dev.themes.components 1.0
import com.dev.themes.singletons 1.0

Feature {
    id: root

    readonly property alias loaderLayout: loaderLayout
    readonly property alias highlightsStore: loaderLayout.highlightsStore

    background {
        anchors.fill: loaderLayout
        color: "black"
        opacity: 0.5
        visible: false
    }

    ExtendedLoader {
        id: loaderLayout

        readonly property real __fullHeight: root.height - loaderLayout.anchors.margins * 2
        readonly property var __newHighlights: highlightsStore.newHighlights
        readonly property HighlightsStore highlightsStore: HighlightsStore {}

        anchors {
            bottom: parent.bottom
            left: parent.left
        }
        width: (1/4) * screen.width

        state: !!loaderLayout.item ? loaderLayout.item.state : "open"
        states: [
            State {
                name: "close"

                PropertyChanges {
                    target: root
                    background.visible: false
                }
                PropertyChanges {
                    target: loaderLayout
                    clip: false
                }
            },
            State {
                name: "whole open"

                PropertyChanges {
                    target: root
                    background.visible: true
                }
                PropertyChanges {
                    target: loaderLayout
                    clip: true
                }
            },
            State {
                name: "open"

                PropertyChanges {
                    target: root
                    background.visible: false
                }
                PropertyChanges {
                    target: loaderLayout
                    clip: false
                }
            }
        ]
    }
}
