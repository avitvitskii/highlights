import QtQml 2.2

import com.dev.themes.singletons 1.0

HighlightsChannel {
    id: root

    function parse(channelConfig, onFinished) {
        resolveAliases(channelConfig.data.url, function onResolved(strResolved) {
            fetchHighlightData(strResolved);
        });
        state.ui.highlightDataChanged.connect(function onDataFetched() {
            state.ui.highlightDataChanged.disconnect(onDataFetched);
            var data = state.ui.highlightData;
            titles = root.applyJsonPath(data, channelConfig.title);
            descriptions = root.applyJsonPath(data, channelConfig.description);
            if (!!channelConfig.analytics && typeof channelConfig.analytics.payload !== "undefined") {
                analytics = JSON.parse(JSON.stringify(channelConfig.analytics));
                Object.keys(analytics.payload).forEach(function collectPayload(payloadName) {
                    analytics.payload[payloadName] = root.applyJsonPath(analytics.payload[payloadName]);
                });
            }
            collectActions(channelConfig.action, data);
            onFinished();
        });
        id = channelConfig.id;
        image.url = channelConfig.image.url;
        typeId = channelConfig.typeId;
    }
    function applyJsonPath(obj, query) {
        var result = JsonPath.jsonPath(obj, query);
        return !!result ? result : [];
    }
    function resolveAliases(strAlias, callback) {
        if (strAlias.indexOf("(destination)") === -1 || strAlias.indexOf("(origin)") === -1) {
            callback(strAlias);
        }

        var oFeatureItem = featuresController.readyFeatures.byId[ThemeConstants.featureIds.destinationGuide];
        if (!!oFeatureItem && !!oFeatureItem.item) {
            var oNavigationService = flightProgressProvider.navigationService;
            var destination = (!!oNavigationService && !!oNavigationService.destination)
                ? oNavigationService.destination.iata || oNavigationService.destination.icao
                : "";
            var origin = (!!oNavigationService && !!oNavigationService.origin)
                ? oNavigationService.origin.iata || oNavigationService.origin.icao
                : "";

            oFeatureItem.item.fetchDestinationIdByCode(destination, function onGetDestination(destinationId) {
                strAlias = strAlias.replace("(destination)", destinationId);

                oFeatureItem.item.fetchDestinationIdByCode(origin, function onGetOrigin(originId) {
                    strAlias = strAlias.replace("(origin)", originId);
                    callback(strAlias);
                });
            });
        } else {
            callback(strAlias);
        }
    }
    function collectActions(action, data) {
        switch (action.typeId) {
            case "destGuideDestination":
            case "destGuideSpot":
                var oFeatureItem = featuresController.readyFeatures.byId[ThemeConstants.featureIds.destinationGuide];
                if (!!oFeatureItem && !!oFeatureItem.item) {
                    var destinationIds = applyJsonPath(data, action.payload.destination);
                    destinationIds.forEach(function iterateDestinations(destinationId) {
                        actions.push(function onClicked() {
                            featuresController.showFeature(ThemeConstants.featureIds.destinationGuide);
                            oFeatureItem.item.updateUIState({spot: destinationId});
                        });
                    });
                }
                break;
            default:
                break;
        }
    }
}
