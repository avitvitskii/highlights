Qt.include("Actions.js");
Qt.include("qrc:///qml/com/dev/themes/singletons/HttpRequests.js");

var configURIs = [];
var serviceBaseURI = "";

function dispatchFetchConfigRequest() {
    fetchAndParse(configURIs,
                  dispatchFetchConfigSuccess,
                  dispatchFetchConfigError);
}
function dispatchFetchConfigSuccess(data) {
    WorkerScript.sendMessage(fetchConfigSuccess(data));
}
function dispatchFetchConfigError() {
    WorkerScript.sendMessage(fetchConfigError());
}
function dispatchFetchHighlightDataRequest(action) {
    fetchAndParse(action.payload,
                  dispatchFetchHighlightDataSuccess,
                  dispatchFetchHighlightDataError);
}
function dispatchFetchHighlightDataSuccess(data) {
    WorkerScript.sendMessage(fetchHighlightDataSuccess(data));
}
function dispatchFetchHighlightDataError() {
    WorkerScript.sendMessage(fetchHighlightDataError());
}
function fetch(URLs, success, error) {
    var index = 0;
    (function defineConfigurationToUse(URL) {
        getRequest(URL, {
            onSuccess: success,
            onError: function onError(status, responseText) {
                if (typeof error === "function") {
                    // console.error log specially disabled for 404 error type
                    // (PAC-11349, PAC-12501)
                    var log = status.code === 404 ? console.info : console.error;
                    log("[HL] cannot fetch URI '%1': status code %2"
                        .arg(URL)
                        .arg(status.code));
                    error(status, responseText);
                }

                ++index;
                if (URLs instanceof Array && index < URLs.length) {
                    defineConfigurationToUse(URLs[index]);
                }
            },
            onNetworkError: function onNetworkError() {
                console.error("[HL] cannot fetch URI '%1': network error".arg(URL));
                error();

                ++index;
                if (URLs instanceof Array && index < URLs.length) {
                    defineConfigurationToUse(URLs[index]);
                }
            },
        });
    })(URLs instanceof Array ? URLs[index] : URLs);
}
function parse(data, success, error) {
    try {
        data = JSON.parse(data);
    } catch (e) {
        console.trace();
        console.warn("error=%1".arg(e));
        if (typeof error === "function") {
            error(e);
        }
        return;
    }
    if (typeof success === "function") {
        success(data);
    }
}
function fetchAndParse(URLs, success, error) {
    fetch(URLs, function onFetchSuccess(responseText) {
        parse(responseText, success, error);
    }, error);
}

WorkerScript.onMessage = function(message) {
    switch (message.type) {
        case "[HL] setup-worker-config":
            configURIs = message.payload;
            break;
        case FETCH_CONFIG_REQUEST:
            dispatchFetchConfigRequest();
            break;
        case FETCH_HIGHLIGHT_DATA_REQUEST:
            dispatchFetchHighlightDataRequest(message);
            break;
    }
}
