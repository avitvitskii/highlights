import QtQuick 2.6

import com.betria.apps 1.1
import com.betria.map3d 1.0

import "./"

QtObject {
    id: root

    readonly property bool ready: !!navigationService

    readonly property HighlightsStore dataStore: HighlightsStore {}
    property var configuration: ({})
    property var configurationUriList: []
    readonly property var aliasProcessor: App.aliasProcessor()
    property var navigationService: null

    signal navigationServiceResponse(var service)

    signal configureFinished()

    function setup(configurationURIs) {
        dataStore.setup(configurationURIs);
        // configurationUriList = aliasProcessor.resolve(configurationURIs).split(",");
        // if (!configurationUriList.length) {
        //     return;
        // }

        // __setup();
        // dataStore.fetchConfig(onSuccess);
    }
    function setupServices(engine) {
        console.assert(!!engine, "[HL] Backend: no valid Map3DEngine instance provided!");

        engine.serviceRequest(Map3DEngine.ServiceNavigation,
                              navigationServiceResponse);
    }

    onConfigurationChanged: console.log("<<!>>configuration: " + JSON.stringify(configuration))

    onReadyChanged: {
        if (ready) {
            function onSuccess(action) {
                configuration = action.payload;
            }

            dataStore.fetchConfig(onSuccess);
        }
    }
}
