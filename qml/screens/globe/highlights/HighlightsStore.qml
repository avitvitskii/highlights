import QtQml 2.2

import com.dev.apps 1.1
import com.dev.map3d 1.0
import com.dev.themes.singletons 1.0

import "Actions.js" as Actions

QtObject {
    id: root

    readonly property bool ready: !!navigationService

    readonly property DataState state: DataState {}

    property var channels: Object.freeze({
        all: [], // HighlightsChannel
        byId: {}
    })
    property var displayedChannels: []
    property int channelsCounter: -1
    property var configuration: ({})
    property var configurationUriList: []
    property bool configured: false
    property int cycleCounter: 0
    property int displayAmount: 2
    property int feedAmount: 100
    property int feedGenerator: 0
    property bool firstRun: true
    property int launchDelay: 5000
    property bool opened: true
    property int refreshFeedInterval: 6000
    property bool showAll: false

    property var newHighlights: []

    readonly property Timer timerFeedGenerator: Timer {
        id: timerFeedGenerator

        interval: refreshFeedInterval
        onTriggered: {
            function refreshFeed() {
                topUpFeed();
                timerFeedGenerator.start();
            }

            channelsCounter += 1;
            if (channelsCounter !== channels.all.length) {
                refreshFeed();
                return;
            }

            updateCycle(refreshFeed);
        }
    }
    property var navigationService: null

    signal navigationServiceResponse(var service)

    signal configureFinished()
    signal dispatch(var action)

    function setup(configurationURIs, onFinished) {
        configurationUriList = App.aliasProcessor().resolve(configurationURIs).split(",");
        if (!configurationUriList.length) {
            return;
        }

        if (typeof onFinished === "function") {
            configureFinished.connect(function onFinishedWrapper() {
                configureFinished.disconnect(onFinishedWrapper);
                onFinished();
            });
        }

        __setup();
        __setupServices();
    }
    function fetchConfig(success) {
        dispatch(Actions.fetchConfigRequest());
    }
    function fetchHighlightData(dataURI) {
        var oDestination = navigationService.destination;
        dataURI = dataURI.replace("$(POINT)", "%1,%2".arg(oDestination.latitude).arg(oDestination.longitude));
        dispatch(Actions.fetchHighlightDataRequest(App.aliasProcessor().resolve(dataURI)));
    }
    function updateCycle(onCompleted) {
        channelsCounter = 0;
        cycleCounter += 1;
        prepareChannels(function onChannelsCompleted() {
            if (typeof onCompleted === "function") {
                onCompleted();
            }
        });
    }
    function prepareChannels(onCompleted) {
        var nCycleSerialNumber = cycleCounter + 1;
        var arrDisplayedFeed = configuration.feed.filter(function filterChannels(channel) {
            var oChannelDisplaySettings = channel.settings.display;
            if (nCycleSerialNumber === 1) {
                return oChannelDisplaySettings.onFirstCycle;
            }
            return nCycleSerialNumber % oChannelDisplaySettings.interval === 0;
        });

        var arrChannelsObjects = [];
        var nCompletedCount = 0;
        arrDisplayedFeed.forEach(function createHighlightChannel(channelConfig) {
            switch (channelConfig.typeId) {
                case "fop":
                    var component = "FopHighlightsChannel.qml";
                    break;
                case "flightInfo":
                    component = "FlightInfoHighlightsChannel.qml";
                    break;
                case "JSONPath":
                    component = "JsonPathHighlightsChannel.qml";
                    break;
                case "basic":
                default:
                    component = "HighlightsChannel.qml"
                    break;
            }
            var oHighlightChannelsComponent = Qt.createComponent(component, root);
            if (oHighlightChannelsComponent.status === Component.Error) {
                console.warn(oHighlightChannelsComponent.errorString());
                return;
            }

            var oHighlightsChannel = oHighlightChannelsComponent.createObject();
            oHighlightsChannel.parse(channelConfig, function onFinished() {
                if (oHighlightsChannel.isValid()) {
                    arrChannelsObjects.push(oHighlightsChannel);
                }

                nCompletedCount++;
                if (nCompletedCount === arrDisplayedFeed.length) {
                    channels = __parseChannels(arrChannelsObjects);
                    if (typeof onCompleted === "function") {
                        onCompleted();
                    }
                }
            });
        });

    }
    function prepareGuide() {
        newHighlights = [
            {
                title: "",
                description: "Hi",
                guide: true,
                image: {
                    url: ""
                },
                analytics: {}
            },
            {
                title: "",
                description: "I\'m here to share information that might interest you",
                guide: true
            }
        ]
    }
    function topUpFeed() {
        if (!channels.all.length) {
            return;
        }
        var channel = channels.byId[channels.all[channelsCounter]];

        if (channel.typeId === "fop" && featuresController.currentFeature === ThemeConstants.featureIds.geoObjects) {
            return;
        }

        var analytics;
        if (!!channel.analytics && !!channel.analytics.target && !!channel.analytics.payload) {
            analytics = JSON.parse(JSON.stringify(channel.analytics));
            Object.keys(analytics.payload).forEach(function collectPayload(payloadName) {
                analytics.payload[payloadName] = analytics.payload[payloadName][cycleCounter % analytics.payload[payloadName].length];
            });
        }

        newHighlights = [
            {
                title: channel.titles[cycleCounter % channel.titles.length],
                description: channel.descriptions[cycleCounter % channel.descriptions.length],
                image: {
                    url: App.aliasProcessor().resolve(channel.image.url)
                },
                analytics: analytics,
                onClicked: channel.actions[cycleCounter % channel.actions.length]
            }
        ]
    }
    function __parseChannels(arrChannels) {
        return arrChannels.reduce(function(channels, channel) {
            if (typeof channels.byId[channel.id] === "undefined") {
                channels.all.push(channel.id);
                channels.byId[channel.id] = channel;
            }
            return channels;
        }, Object.freeze({
            all: [],
            byId: {}
        }));
    }
    function __setup() {
        var oComponent = Qt.createComponent("Dispatcher.qml");

        function createDispatcher() {
            var oDispatcher = oComponent.createObject(
                        root, { configURIs: configurationUriList,
                                dataStore: root });
            dispatch.connect(oDispatcher.dispatch);
        }

        if (oComponent.status === Component.Ready) {
            createDispatcher();
        } else {
            oComponent.statusChagned.connect(function onComponentStatusChagned() {
                if (oComponent.status === Component.Ready) {
                    oComponent.statusChagned.disconnect(onComponentStatusChagned);
                    createDispatcher();
                }
            });
        }
    }
    function __setupServices() {
        engine.serviceRequest(Map3DEngine.ServiceNavigation,
                              navigationServiceResponse);
    }

    onConfigurationChanged: {
        if (!configuration || typeof configuration.feed === "undefined") {
            return;
        }
        configured = true;
        configureFinished();

        prepareChannels(function onCompleted() {
            if (channels.all.length) {
                prepareGuide();
                timerFeedGenerator.start();
            }
        });
    }
    onDispatch: {
        switch (action.type) {
            case Actions.FETCH_CONFIG_SUCCESS:
                (function dispatchFetchConfigSuccess(action) {
                    configuration = action.payload;
                })(action);
                break;
            case Actions.FETCH_CONFIG_ERROR:
                break;
            case Actions.FETCH_HIGHLIGHT_DATA_SUCCESS:
                (function dispatchFetchHighlightDataSuccess(action) {
                    state.ui.highlightData = action.payload;
                })(action);
                break;
            case Actions.FETCH_HIGHLIGHT_DATA_ERROR:
                break;
        }
    }
    onNavigationServiceResponse: navigationService = service
    onReadyChanged: fetchConfig()
}
