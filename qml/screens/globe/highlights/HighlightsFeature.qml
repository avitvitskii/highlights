import QtQuick 2.6
import QtQuick.Controls 1.4

import com.dev.themes.singletons 1.0

HighlightsFeatureForm {
    id: root

    readonly property bool isInclusiveFeature: true
    readonly property bool isWhole: !!loaderLayout.item && loaderLayout.item.isWhole

    closable: false
    hideDiscreteControls: false
    hideFindButtons: false
    pushTransition: StackViewTransition {
        PropertyAnimation {
            target: enterItem
            duration: 250
            property: "opacity"
            from: 0
            to: 1
        }
    }
    popTransition: StackViewTransition {
        PropertyAnimation {
            target: exitItem
            duration: 250
            property: "opacity"
            from: 1
            to: 0
        }
    }
    loaderLayout {
        active: true
        sourceComponent: Qt.createComponent("HighlightsLayout.qml", root)
    }
    onVisibleChanged: visible && loaderLayout.state === "open"
                      ? highlightsStore.timerFeedGenerator.start()
                      : highlightsStore.timerFeedGenerator.stop()
    Component.onCompleted: featuresController.currentFeatureChanged.connect(function onCurrentFeatureChanged() {
        if ([ThemeConstants.featureIds.ddi,
             ThemeConstants.featureIds.fcl,
             ThemeConstants.featureIds.geoObjects,
             ThemeConstants.featureIds.groundFlights,
             ThemeConstants.featureIds.highlights,
             ThemeConstants.featureIds.timeToMiqat].indexOf(featuresController.currentFeature) === -1) {
            root.visible = false;
            if (loaderLayout.state === "whole open" && !!loaderLayout.item) {
                loaderLayout.item.isWhole = false;
            }
        } else {
            root.visible = true;
        }
    })
}
