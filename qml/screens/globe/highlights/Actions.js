.pragma library

var FETCH_CONFIG_REQUEST = "[FOP] fetch-config-request";
var FETCH_CONFIG_SUCCESS = "[FOP] fetch-config-success";
var FETCH_CONFIG_ERROR = "[FOP] fetch-config-error";
var FETCH_HIGHLIGHT_DATA_REQUEST = "[FOP] fetch-highlight-data-request";
var FETCH_HIGHLIGHT_DATA_SUCCESS = "[FOP] fetch-highlight-data-success";
var FETCH_HIGHLIGHT_DATA_ERROR = "[FOP] fetch-highlight-data-error";

function fetchConfigRequest() {
    return Object.freeze({
        type: FETCH_CONFIG_REQUEST
    });
}
function fetchConfigSuccess(config) {
    return Object.freeze({
        type: FETCH_CONFIG_SUCCESS,
        payload: config
    });
}
function fetchConfigError() {
    return Object.freeze({
        type: FETCH_CONFIG_ERROR
    });
}
function fetchHighlightDataRequest(dataURI) {
    return Object.freeze({
        type: FETCH_HIGHLIGHT_DATA_REQUEST,
        payload: dataURI
    });
}
function fetchHighlightDataSuccess(data) {
    return Object.freeze({
        type: FETCH_HIGHLIGHT_DATA_SUCCESS,
        payload: data
    });
}
function fetchHighlightDataError() {
    return Object.freeze({
        type: FETCH_HIGHLIGHT_DATA_ERROR
    });
}

