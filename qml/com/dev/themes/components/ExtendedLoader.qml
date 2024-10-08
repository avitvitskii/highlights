import QtQuick 2.6

Loader {
    id: root

    readonly property bool ready: !sourceComponent
                                  || (status === Loader.Ready
                                      && !!item && (typeof item.ready !== 'boolean' || item.ready))
}
