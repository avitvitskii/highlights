import QtQuick 2.6
import QtQuick.Controls 1.4

import com.dev.apps 1.1
import com.dev.themes.controls 1.0
import com.dev.themes.singletons 1.0

FeatureForm {
    id: root

    property bool ready: true

    property string featureId: ""
    property bool embedded: false
    readonly property bool isOpened: root.Stack.status === Stack.Active
    readonly property bool isInclusiveFeature: false
    property bool closable: true
    property bool hideDiscreteControls: !embedded
    property bool hideFindButtons: !embedded
    property AbstractButton button: null
    property var firstFocusItem: closeButton.visible ? closeButton : "[VS] tongue"
    property Component pushTransition: StackViewTransition {
        PropertyAnimation {
            target: enterItem
            duration: 250
            property: "x"
            from: root.background.width * (App.layoutDirection === Qt.LeftToRight ? -1 : 1)
            to: 0
        }
    }
    property Component popTransition: StackViewTransition {
        PropertyAnimation {
            target: exitItem
            duration: 250
            property: "x"
            from: 0
            to: root.background.width * (App.layoutDirection === Qt.LeftToRight ? -1 : 1)
        }
    }
    property Component replaceTransition: null
    signal updateUIState(var data);

    function onStartUpFeature() {
        console.info("<QML> '%1' feature has no special actions on start.".arg(featureId))
    }
    function enableFeatureButton () {
        if (ready && !!button && typeof button.enabled === "boolean") {
            button.checked = Qt.binding(function () {
                return root.Stack.status >= Stack.Active;
            })
            button.enabled = true;
        }
    }
    function updateNavigationFocus() {
        if (!NavigationController.active) {
            return;
        }

        switch (root.Stack.status) {
            case Stack.Activating:
                NavigationController.focus(firstFocusItem);
                break;
            case Stack.Inactive:
                if (!featuresController.currentFeature) {
                    NavigationController.focus("[VS] tongue");
                }
                break;
            default:
                break;
        }
    }
    function logStatus() {
        switch (root.Stack.status) {
            case Stack.Active:
                logStatusOpen();
                break;
            case Stack.Inactive:
                logStatusClose();
                break;
            default:
                break;
        }
    }
    function logStatusOpen() {
        logUserActivity({
            c: "overlay",
            a: "open",
            t: __logFeatureId(),
        });
    }
    function logStatusClose() {
        logUserActivity({
            c: "overlay",
            a: "close",
            t: __logFeatureId(),
        });
    }
    function __logFeatureId() {
        switch (featureId) {
            case ThemeConstants.featureIds.airlineRouteMap:
                return "route_map";
            case ThemeConstants.featureIds.destinationGuide:
                return "destguide";
            case ThemeConstants.featureIds.flightInformation:
                return "f_info";
            case ThemeConstants.featureIds.geoObjects:
                return "fop";
            case ThemeConstants.featureIds.worldClock:
                return "w_clock";
            default:
                return featureId;
        }
    }

    closeButton.visible: root.closable
    closeButton.onClicked: featuresController.hideFeature(featureId)
    onButtonChanged: enableFeatureButton()
    onReadyChanged: enableFeatureButton()
    Stack.onStatusChanged: {
        updateNavigationFocus();
        logStatus();
    }
    Component.onCompleted: enableFeatureButton()

    Navigation {
        target: closeButton
        enabled: isOpened
        slope: embedded ? 10 : 1
    }
}
