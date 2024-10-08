pragma Singleton

import QtQuick 2.6

import com.dev.apps 1.1
import com.dev.map3d 1.1
import com.dev.themes.components 1.0

import "HttpRequests.js" as Http

QtObject {
    property var http: Http

    readonly property var generateUuid: {
        var macAddress = "";
        if (typeof Device !== "undefined") {
            Object.keys(Device.network.interfaces).some(function iterateInterfaces(interfaceName) {
                if (!!Device.network.interfaces[interfaceName].mac) {
                    var oMacAddress = Device.network.interfaces[interfaceName].mac;
                    oMacAddress = oMacAddress.replace(/[:-]/g, "");
                    if (oMacAddress.length === 12) {
                        macAddress = oMacAddress;
                        return true;
                    }
                    return false;
                }
                return false;
            });
        }

        if (!!macAddress) {
            // Function to generate UUID v1 using MAC address and timestamp
            return function generateUuidV1() {
                var nTimestamp = Date.now();
                var strHexTimestamp = nTimestamp.toString(16);

                strHexTimestamp = "000000000000000" + strHexTimestamp;
                strHexTimestamp = strHexTimestamp.slice(-15);

                var strTimeLow = strHexTimestamp.slice(-8);
                var strTimeMid = strHexTimestamp.slice(-12, -8);
                var strTimeHiAndVersion = strHexTimestamp.slice(-15, -12);

                strTimeHiAndVersion = parseInt(strTimeHiAndVersion, 16) & 0x0FFF;
                strTimeHiAndVersion = (strTimeHiAndVersion | 0x1000).toString(16);

                var strClockSeq = Math.floor(Math.random() * 0x3FFF).toString(16).padStart(4, '0');

                // UUID string in the format: time_low-time_mid-time_hi_and_version-clock_seq-node
                return "%1-%2-%3-%4-%5".arg(strTimeLow).arg(strTimeMid).arg(strTimeHiAndVersion).arg(strClockSeq).arg(macAddress);
            }
        }

        // Function to generate a random UUID v4
        console.info("No valid MAC address available to generate UUID v1. Generating UUID v4.");
        return function generateUuidV4() {
            function randomHexDigit() {
                return Math.floor(Math.random() * 16).toString(16);
            }

            var uuid = "%1%2%3%4-%5%6-%7%8-%9%10-%11%12%13%14%15%16"
                        .arg(randomHexDigit()).arg(randomHexDigit()).arg(randomHexDigit()).arg(randomHexDigit()) // time_low
                        .arg(randomHexDigit()).arg(randomHexDigit())                                             // time_mid
                        .arg('4').arg(randomHexDigit())                                                          // time_hi and version (version 4)
                        .arg((8 + Math.floor(Math.random() * 4)).toString(16)).arg(randomHexDigit())             // clock_seq_hi (8, 9, A, or B)
                        .arg(randomHexDigit()).arg(randomHexDigit()).arg(randomHexDigit()).arg(randomHexDigit()) // node part 1
                        .arg(randomHexDigit()).arg(randomHexDigit());                                            // node part 2

            return uuid;
        };
    }

    function toBooleanOr(value, def) {
        return typeof value !== "undefined" ? !!value : def;
    }
    function dateToObject(date, units) {
        QT_TRID_NOOP("am");
        QT_TRID_NOOP("pm");

        switch (__units(units)) {
            case UnitSystem.Imperial:
                var strUnits = App.resources.strings[date.toLocaleString(Qt.locale("C"), "a")];
                // NOTE: Fallback for cases when no "am", "pm" translations exists
                if (strUnits === "!") {
                    strUnits = date.toLocaleString(Qt.locale(), "a");
                }
                var oLocale = Qt.locale(App.languageCode === "ar" ? "C" : "");
                return Object.freeze({
                    unit: strUnits,
                    value: date.toLocaleString(oLocale, "%1a".arg("h:mm"))
                           .replace(date.toLocaleString(oLocale, "a"), "")
                });
            case UnitSystem.Metric:
                return Object.freeze({
                    unit: "",
                    value: date.toLocaleString(Qt.locale("C"), "hh:mm"),
                });
        }
    }
    function fixTimezone(ms, timezone) {
        if (typeof timezone === "undefined") {
            timezone = 0;
        }
        var localZoneOffset = (new Date(ms)).getTimezoneOffset() * 60 * 1000;
        return new Date(ms + localZoneOffset + timezone);
    }
    function __units(units) {
        return typeof units === "number" && units || App.unitSystem;
    }
    // NOTE: NaN is a valid return value
    function greatCircleDistance(lat0, lon0, lat1, lon1) {
        if (lat0 === lat1 && lon0 === lon1) {
            return 0;
        }

        var a = Math.sin((lat1 - lat0) / 2.0);
        var b = Math.sin((lon1 - lon0) / 2.0);
        var c = a * a + Math.cos(lat0) * Math.cos(lat1) * b * b;
        var d = 2.0 * Math.asin(Math.sqrt(c));

        return d;
    }
    // NOTE: NaN is a valid return value
    function greatCircleAzimuth(lat0, lon0, lat1, lon1) {
        if (lat0 === lat1 && lon0 === lon1) {
            return 0;
        }
        if (lon0 === lon1) {
            return lat0 > lat1? Math.PI : 0;
        }

        var nY = Math.cos(lat1) * Math.sin(lon1 - lon0);
        var nX = Math.cos(lat0) * Math.sin(lat1) - Math.sin(lat0) * Math.cos(lat1) * Math.cos(lon1 - lon0);
        var nA = Math.atan2(nY, nX);

        return nA;
    }

    function formatWaypointName(waypoint, waypointNameFormat) {
        if (!waypoint) {
            return "";
        }
        if (typeof waypointNameFormat === "undefined") {
            waypointNameFormat = App.layoutDirection === Qt.LeftToRight
                                 ? "%1/%2" : "%2/%1";
        }

        var strDisplay = waypoint.name && App.resources.strings[waypoint.name];
        var strShortName = waypoint.shortName && App.resources.strings[waypoint.shortName];
        if (strShortName !== waypoint.shortName) {
            strDisplay = waypointNameFormat.arg(strDisplay).arg(strShortName);
        }

        return strDisplay;
    }
    function formatWaypointCode(waypoint) {
        return !!waypoint ? waypoint.IATA : "";
    }
    function setPreviewImage(imageItem, source, contentUri) {
        var url = "%1/previews/%2".arg(contentUri).arg(source);
        Http.headRequest(App.aliasProcessor().resolve(url), {
            onSuccess: function onSuccess() {
                imageItem.source = url;
            },
            onError: function onError(status) {
                console.info("Cannot fetch source '%1': status code %2"
                             .arg(url)
                             .arg(status.code))
                __updatePreview(imageItem, source, contentUri);
            },
        });
    }
    function __updatePreview(imageItem, source, contentUri, defaultName) {
        if (typeof defaultName === "undefined") {
            defaultName = "default.png";
        }

        if (source === defaultName) {
            imageItem.source = "qrc:///qml/screens/globe/airlineroutemap/images/city_icon.png";
        } else {
            setPreviewImage(imageItem, defaultName, contentUri);
        }
    }

    function findNextGridViewNavigatableItem(action, item, gridView) {
        gridView = typeof gridView !== "undefined" ? gridView : item.GridView.view;

        var oNextItemPoint = Qt.point(item.x + gridView.cellWidth / 2, item.y + gridView.cellHeight / 2);
        switch (action.type) {
            case Navigation.NavigateDown:
                oNextItemPoint.y += gridView.cellHeight;
                if (oNextItemPoint.y > gridView.originY + gridView.contentHeight) {
                    return;
                }
                break;
            case Navigation.NavigateLeft:
                oNextItemPoint.x -= gridView.cellWidth;
                if (oNextItemPoint.x < gridView.originX) {
                    return;
                }
                break;
            case Navigation.NavigateRight:
                oNextItemPoint.x += gridView.cellWidth;
                if (oNextItemPoint.x > gridView.originX + gridView.contentWidth) {
                    return;
                }
                break;
            case Navigation.NavigateUp:
                oNextItemPoint.y -= gridView.cellHeight;
                if (oNextItemPoint.y < gridView.originY) {
                    return;
                }
                break;
            default:
                break;
        }

        return gridView.itemAt(oNextItemPoint.x, oNextItemPoint.y);
    }
    function updateListModel(model, items) {
        if (!items) {
            model.clear();
            return;
        }

        if (!(items instanceof Array)
            && typeof items.count === "number"
            && typeof items.get === "function") {
            var oSourceModel = items;
            items = [];
            for (var index = 0; index < oSourceModel.count; ++index) {
                items.push(oSourceModel.get(index));
            }
        }

        if (items.length === 0) {
            model.clear();
            return;
        }

        var arrToAppend = items.reduce(function updateModel(toAppend, item, index) {
            if (index < model.count) {
                model.set(index, item);
            } else {
                toAppend.push(item);
            }
            return toAppend;
        }, []);

        if (arrToAppend.length > 0) {
            model.append(arrToAppend);
        } else if (items.length < model.count) {
            model.remove(items.length,
                         model.count - items.length);
        }
    }
    function thiner(color, a) {
        if (typeof a === 'undefined') {
            a = 0.5;
        }
        return Qt.rgba(color.r, color.g, color.b, a * color.a);
    }
}
