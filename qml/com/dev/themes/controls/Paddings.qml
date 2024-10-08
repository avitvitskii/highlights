import QtQml 2.2

QtObject {
    id: root

    property real all: 0.0
    property real bottom: all
    property real left: all
    property real right: all
    property real top: all

    readonly property real __h: left + right
    readonly property real __v: bottom + top
}
