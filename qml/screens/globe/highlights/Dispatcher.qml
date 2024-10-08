import QtQuick 2.6

import "Actions.js" as Actions

QtObject {
    id: root

    property var configURIs: []
    property var dataStore: null
    readonly property WorkerScript __worker: WorkerScript {
        id: worker

        source: Qt.resolvedUrl("DispatcherWorker.js")
        onMessage: root.dataStore.dispatch(messageObject)
    }

    signal dispatch(var action)

    onDispatch: {
        switch (action.type) {
            case Actions.FETCH_CONFIG_REQUEST:
            case Actions.FETCH_HIGHLIGHT_DATA_REQUEST:
                worker.sendMessage(action);
                break;
            default:
                break;
        }
    }
    Component.onCompleted: worker.sendMessage({ type: "[HL] setup-worker-config",
                                                payload: configURIs
                                              })
}
