.pragma library

function getRequest(url, callbacks, headers) {
    return sendRequest("GET", url, callbacks, null, true, headers);
}
function headRequest(url, callbacks, headers) {
    return sendRequest("HEAD", url, callbacks, null, true, headers);
}
function postRequest(url, callbacks, body, async, headers) {
    if (typeof body === 'undefined') {
        body = null;
    }
    if (typeof async === 'undefined') {
        async = true;
    }
    return sendRequest("POST", url, callbacks, body, async, headers);
}
function sendRequest(method, url, callbacks, body, async, headers) {
    if (typeof body === 'undefined') {
        body = null;
    }
    if (typeof async === 'undefined') {
        async = true;
    }
    if (!url) {
        console.info("sendRequest is called without url");
        return;
    }
    var request = new XMLHttpRequest();

    function handle() {
        switch (request.readyState) {
            case XMLHttpRequest.DONE:
                if (!!callbacks && typeof callbacks.onDone === "function") {
                    callbacks.onDone();
                }
                switch (request.status) {
                    case 200:
                    case 304:
                        if (!!callbacks && typeof callbacks.onSuccess === "function") {
                            callbacks.onSuccess(request.responseText,
                                                request.getAllResponseHeaders() || "");
                        }
                        break;
                    case 404:
                    case 500:
                        if (!!callbacks && typeof callbacks.onUnknown === "function") {
                            callbacks.onUnknown();
                        }
                        // NOTE: continue to onError from here
                    default:
                        if (!!callbacks && typeof callbacks.onError === "function") {
                            var status = {
                                code: request.status,
                                message: request.statusText
                            };
                            callbacks.onError(status, request.responseText);
                        }
                        break;
                }
                if (!!callbacks && typeof callbacks.finalize === "function") {
                    callbacks.finalize(request.status);
                }
                request = undefined;
                break;
            default:
                break;
        }
    }

    if (async) {
        if (!!callbacks && typeof callbacks.onNetworkError === "function") {
            request.onerror = callbacks.onNetworkError;
        }
        request.onreadystatechange = handle;
    }

    request.open(method, url, async);
    if (!!headers && typeof headers === "object") {
        Object.keys(headers).forEach(function iterateHeaders(header) {
            request.setRequestHeader(header, headers[header]);
        });
    }
    request.send(body);

    if (async) {
        return function abort() {
            if (!!request && request.readyState !== XMLHttpRequest.DONE) {
                request.abort();
            }
        }
    } else {
        handle();
    }
}
