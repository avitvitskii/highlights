import QtQml 2.2

import com.dev.themes.singletons 1.0

HighlightsChannel {
    id: root

    function parse(channelConfig, onFinished) {
        id = channelConfig.id;
        image.url = channelConfig.image.url;
        typeId = channelConfig.typeId;
        analytics = channelConfig.analytics || null;
        actions.push(function onClicked() {
            featuresController.showFeature(ThemeConstants.featureIds.flightInformation);
        });
        var oFeatureItem = featuresController.readyFeatures.byId[ThemeConstants.featureIds.flightInformation];
        if (!!oFeatureItem && !!oFeatureItem.item) {
            var provider = oFeatureItem.item.provider;
            provider.update();
            provider.onFetched.connect(function onDataFetched(data) {
                provider.onFetched.disconnect(onDataFetched);
                data.fields.forEach(function iterateFields(field) {
                    titles.push(field.label);
                    descriptions.push(field.value);
                });
                onFinished();
            });
        } else {
            onFinished();
        }
    }
}
