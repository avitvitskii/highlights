import QtQml 2.2

import com.dev.apps 1.1
import com.dev.themes.singletons 1.0

HighlightsChannel {
    id: root

    readonly property string unitsLabel: App.resources.strings[App.unitSystem === UnitSystem.Imperial
                                                               ? App.languageCode === "en"
                                                                 ? Translations.fop_miles
                                                                 : Translations.fop_mi
                                                               : Translations.fop_km]

    function parse(channelConfig, onFinished) {
        id = channelConfig.id;
        image.url = channelConfig.image.url;
        typeId = channelConfig.typeId;
        if (!!channelConfig.analytics) {
            analytics = JSON.parse(JSON.stringify(channelConfig.analytics));
        }

        var oFeatureItem = featuresController.readyFeatures.byId[ThemeConstants.featureIds.geoObjects];
        if (!!oFeatureItem && !!oFeatureItem.item) {
            var oFopFeature = oFeatureItem.item;

            function getFopData() {
                var oBackend = oFopFeature.backend;
                oBackend.fop.state.ui.places.forEach(function iteratePlaces(place) {
                    titles.push("%1 %2 %3".arg(__calculateDistance(oBackend.state.navigation.latitude,
                                                                  oBackend.state.navigation.longitude,
                                                                  place.position.lat * Math.PI / 180.0,
                                                                  place.position.lon * Math.PI / 180.0))
                                         .arg(unitsLabel.toLowerCase())
                                         .arg(__calculateCardinalDirection(oBackend.state.navigation.latitude,
                                                                           oBackend.state.navigation.longitude,
                                                                           place.position.lat * Math.PI / 180.0,
                                                                           place.position.lon * Math.PI / 180.0)));
                    descriptions.push(place.title);
                    if (!!analytics && typeof analytics.payload !== "undefined") {
                        if (typeof analytics.payload.fopId === "undefined") {
                            analytics.payload = Object.assign({}, analytics.payload, { fopId: [].concat(place.id) });
                        } else {
                            analytics.payload.fopId.push(place.id);
                        }
                    }

                    actions.push(function onClicked() {
                        oFopFeature.setCurrentFop(place.id);
                        featuresController.showFeature(ThemeConstants.featureIds.geoObjects);
                    });
                });
            }

            if (oFopFeature.ready) {
                getFopData();
                onFinished();
            } else {
                oFopFeature.readyChanged.connect(function onFopReady() {
                    oFopFeature.readyChanged.disconnect(onFopReady);
                    getFopData();
                    onFinished();
                });
            }

            return;
        }

        onFinished();
    }
    function __calculateCardinalDirection(latRad, lonRad, endLatRad, endLonRad) {
        if (isNaN(latRad)
            || isNaN(lonRad)
            || isNaN(endLatRad)
            || isNaN(endLonRad)) {
            return "";
        }
        var nAzimuthRadians = Utils.greatCircleAzimuth(latRad, lonRad,
                                                       endLatRad, endLonRad);
        if (isNaN(nAzimuthRadians)) {
            return "";
        }
        return Translations.directionLabel(
                    (nAzimuthRadians / Math.PI * 180 + 360 ) % 360 || 0);
    }
    function __calculateDistance(latRad, lonRad, endLatRad, endLonRad) {
        if (isNaN(latRad)
            || isNaN(lonRad)
            || isNaN(endLatRad)
            || isNaN(endLonRad)) {
            return 0;
        }
        var nDistance = Utils.greatCircleDistance(latRad, lonRad,
                                                  endLatRad, endLonRad);
        if (isNaN(nDistance)) {
            return 0;
        }
        return Math.round(nDistance * 6371 / (App.unitSystem === UnitSystem.Imperial ? 1.60934 : 1));
    }
}
