import QtQml 2.2

import com.dev.themes.singletons 1.0

QtObject {
    id: root

    property var id: 0
    property var titles: []
    property var descriptions: []
    property var image: ({
        url: ""
    })
    property var actions: []
    property var analytics: null
    property string typeId: ""

    function parse(channelConfig, onFinished) {
        id = channelConfig.id;
        image.url = channelConfig.image.url;
        typeId = channelConfig.typeId;
        titles = !!channelConfig.title ? resolveAliases(channelConfig.title) : [];
        descriptions = !!channelConfig.description ? resolveAliases(channelConfig.description) : [];
        analytics = channelConfig.analytics || null;
        collectActions(channelConfig.action, data);
        onFinished();
    }
    function isValid() {
        if (isNaN(id)) {
            return false;
        }

        return (!!titles && titles.length > 0) || (!!descriptions && descriptions.length > 0);
    }
    function resolveAliases(strAlias) {
        strAlias = strAlias
        .replace("(destination)", !!flightProgressProvider.navigationService && !!flightProgressProvider.navigationService.destination
                 ? flightProgressProvider.navigationService.destination.city
                 : "")
        .replace("(origin)", !!flightProgressProvider.navigationService && !!flightProgressProvider.navigationService.origin
                 ? flightProgressProvider.navigationService.origin.city
                 : "");
        return !!strAlias ? [].concat(strAlias) : [];
    }

    function collectActions(action, data) {
        switch (action.typeId) {
            case "destGuideDestination":
                var oFeatureItem = featuresController.readyFeatures.byId[ThemeConstants.featureIds.destinationGuide];
                if (!!oFeatureItem && !!oFeatureItem.item) {
                    var spot = !!flightProgressProvider.navigationService && !!flightProgressProvider.navigationService.destination
                                ? flightProgressProvider.navigationService.destination.iata || flightProgressProvider.navigationService.destination.icao
                                : undefined;
                    actions.push(function onClicked() {
                        featuresController.showFeature(ThemeConstants.featureIds.destinationGuide);
                        oFeatureItem.item.updateUIState({spot: spot});
                    });
                }
                break;
            case "destGuideOrigin":
                oFeatureItem = featuresController.readyFeatures.byId[ThemeConstants.featureIds.destinationGuide];
                if (!!oFeatureItem && !!oFeatureItem.item) {
                    spot = !!flightProgressProvider.navigationService && !!flightProgressProvider.navigationService.origin
                            ? flightProgressProvider.navigationService.origin.iata || flightProgressProvider.navigationService.origin.icao
                            : undefined;
                    actions.push(function onClicked() {
                        featuresController.showFeature(ThemeConstants.featureIds.destinationGuide);
                        oFeatureItem.item.updateUIState({spot: spot});
                    });
                }
                break;
            default:
                break;
        }

        if (!!spot && !!analytics && (typeof analytics.payload === "undefined" || typeof analytics.payload.poiId === "undefined")) {
            analytics.payload = Object.assign({}, analytics.payload, { poiId: [].concat(spot) });
        }
    }
}
