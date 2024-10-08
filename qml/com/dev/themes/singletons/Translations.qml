pragma Singleton

import QtQml 2.2
import com.dev.apps 1.1

QtObject {
    readonly property string generic_e: QT_TRID_NOOP("generic:E")
    readonly property string generic_n: QT_TRID_NOOP("generic:N")
    readonly property string generic_ne: QT_TRID_NOOP("generic:NE")
    readonly property string generic_nw: QT_TRID_NOOP("generic:NW")
    readonly property string generic_s: QT_TRID_NOOP("generic:S")
    readonly property string generic_se: QT_TRID_NOOP("generic:SE")
    readonly property string generic_sw: QT_TRID_NOOP("generic:SW")
    readonly property string generic_w: QT_TRID_NOOP("generic:W")

    readonly property string generic_km: QT_TRID_NOOP("generic:km")
    readonly property string generic_mi: QT_TRID_NOOP("generic:mi")
    readonly property string generic_miles: QT_TRID_NOOP("generic:miles")

    readonly property string generic_hr: QT_TRID_NOOP("generic:hr")
    readonly property string generic_min: QT_TRID_NOOP("generic:min")

    readonly property string generic_destinations: QT_TRID_NOOP("generic:destinations")

    readonly property string arm_aircraft: QT_TRID_NOOP("arm:aircraft")
    readonly property string arm_any: QT_TRID_NOOP("arm:any")
    readonly property string arm_all: QT_TRID_NOOP("arm:all")
    readonly property string arm_all_interests: QT_TRID_NOOP("arm:all_interests")
    readonly property string arm_arrives: QT_TRID_NOOP("arm:arrives")
    readonly property string arm_departs: QT_TRID_NOOP("arm:departs")
    readonly property string arm_distance: QT_TRID_NOOP("arm:distance")
    readonly property string arm_duration: QT_TRID_NOOP("arm:duration")
    readonly property string arm_flight: QT_TRID_NOOP("arm:flight")
    readonly property string arm_flightTime: QT_TRID_NOOP("arm:flight_time")
    readonly property string arm_from: QT_TRID_NOOP("arm:from")
    readonly property string arm_hr: QT_TRID_NOOP("arm:hr")
    readonly property string arm_interests: QT_TRID_NOOP("arm:interests")
    readonly property string arm_km: QT_TRID_NOOP("arm:km")
    readonly property string arm_manyStops: QT_TRID_NOOP("arm:many_stops")
    readonly property string arm_mi: QT_TRID_NOOP("arm:mi")
    readonly property string arm_min: QT_TRID_NOOP("arm:min")
    readonly property string arm_nonStop: QT_TRID_NOOP("arm:non_stop")
    readonly property string arm_nonStopDepartures: QT_TRID_NOOP("arm:non_stop_departures")
    readonly property string arm_nonStopDestinations: QT_TRID_NOOP("arm:non_stop_destinations")
    readonly property string arm_operatedBy: QT_TRID_NOOP("arm:operated_by")
    readonly property string arm_searchBar: QT_TRID_NOOP("arm:searchBar")
    readonly property string arm_seeDestinations: QT_TRID_NOOP("arm:see_destinations")
    readonly property string arm_seeFlights: QT_TRID_NOOP("arm:see_flights")
    readonly property string arm_stops: QT_TRID_NOOP("arm:stops")
    readonly property string arm_to: QT_TRID_NOOP("arm:to")

    readonly property string cg_arrivalFlight: QT_TRID_NOOP("cg:arrival_flight")
    readonly property string cg_arrivalGate: QT_TRID_NOOP("cg:arrival_gate")
    readonly property string cg_arrivalTime: QT_TRID_NOOP("cg:arrival_time")
    readonly property string cg_departureDestination: QT_TRID_NOOP("cg:destination")
    readonly property string cg_departureFlight: QT_TRID_NOOP("cg:flight")
    readonly property string cg_departureGate: QT_TRID_NOOP("cg:gate")
    readonly property string cg_departureTime: QT_TRID_NOOP("cg:time")
    readonly property string cg_extraInfo: QT_TRID_NOOP("cg:extra_info")
    readonly property string cg_header: QT_TRID_NOOP("cg:header")

    readonly property string ddi_destination: QT_TRID_NOOP("ddi:destination")
    readonly property string ddi_distance: QT_TRID_NOOP("ddi:distance")
    readonly property string ddi_distanceDirecionIndicator: QT_TRID_NOOP("ddi:distance_and_direction_indicator")
    readonly property string ddi_km: QT_TRID_NOOP("ddi:km")
    readonly property string ddi_localTime: QT_TRID_NOOP("ddi:local_time")
    readonly property string ddi_mi: QT_TRID_NOOP("ddi:mi")
    readonly property string ddi_midnightSun: QT_TRID_NOOP("ddi:midnight_sun")
    readonly property string ddi_origin: QT_TRID_NOOP("ddi:origin")
    readonly property string ddi_polarNight: QT_TRID_NOOP("ddi:polar_night")
    readonly property string ddi_sunrise: QT_TRID_NOOP("ddi:sunrise")
    readonly property string ddi_sunset: QT_TRID_NOOP("ddi:sunset")

    readonly property string dg_destination: QT_TRID_NOOP("dg:destination")
    readonly property string dg_exploreAirports: QT_TRID_NOOP("dg:explore_airports")
    readonly property string dg_exploreAttractions: QT_TRID_NOOP("dg:explore_attractions")

    readonly property string fi_altitude: QT_TRID_NOOP("fi:altitude")
    readonly property string fi_distanceToGo: QT_TRID_NOOP("fi:distance_to_go")
    readonly property string fi_hr: QT_TRID_NOOP("fi:hr")
    readonly property string fi_imperial: QT_TRID_NOOP("fi:imperial")
    readonly property string fi_metric: QT_TRID_NOOP("fi:metric")
    readonly property string fi_min: QT_TRID_NOOP("fi:min")
    readonly property string fi_speed: QT_TRID_NOOP("fi:speed")
    readonly property string fi_timeAtDestination: QT_TRID_NOOP("fi:time_at_destination")

    readonly property string gf_aircraftModel: QT_TRID_NOOP("gf:aircraft_model")
    readonly property string gf_flight: QT_TRID_NOOP("gf:flight")

    readonly property string fop_credits: QT_TRID_NOOP("fop:credits")
    readonly property string fop_colon: QT_TRID_NOOP("fop:colon")
    readonly property string fop_km: QT_TRID_NOOP("fop:km")
    readonly property string fop_mi: QT_TRID_NOOP("fop:mi")
    readonly property string fop_miles: QT_TRID_NOOP("fop:miles")

    readonly property string lp_metric: QT_TRID_NOOP("lp:metric")
    readonly property string lp_imperial: QT_TRID_NOOP("lp:imperial")
    readonly property string lp_locationPointer: QT_TRID_NOOP("lp:location_pointer")

    readonly property string mp_distanceToMiqat: QT_TRID_NOOP("mp:distance_to_miqat")
    readonly property string mp_distance: QT_TRID_NOOP("mp:distance")
    readonly property string mp_direction: QT_TRID_NOOP("mp:direction")
    readonly property string mp_km: QT_TRID_NOOP("mp:km")
    readonly property string mp_hr: QT_TRID_NOOP("mp:hr")
    readonly property string mp_min: QT_TRID_NOOP("mp:min")
    readonly property string mp_insideMiqat: QT_TRID_NOOP("mp:inside_miqat")
    readonly property string mp_meccaPointer: QT_TRID_NOOP("mp:mecca_pointer")
    readonly property string mp_miles: QT_TRID_NOOP("mp:miles")
    readonly property string mp_timeToMiqat: QT_TRID_NOOP("mp:time_to_miqat")

    readonly property string pr_beforePrayer: QT_TRID_NOOP("pr:before_prayer")
    readonly property string pr_currentLocation: QT_TRID_NOOP("pr:current_location")
    readonly property string pr_currentTime: QT_TRID_NOOP("pr:current_time")
    readonly property string pr_destination: QT_TRID_NOOP("pr:destination")
    readonly property string pr_hr: QT_TRID_NOOP("pr:hr")
    readonly property string pr_min: QT_TRID_NOOP("pr:min")
    readonly property string pr_mecca: QT_TRID_NOOP("pr:mecca")
    readonly property string pr_now: QT_TRID_NOOP("pr:now")
    readonly property string pr_origin: QT_TRID_NOOP("pr:origin")
    readonly property string pr_prayAfter: QT_TRID_NOOP("pr:pray_after_fmt")
    readonly property string pr_prayFAJR: QT_TRID_NOOP("pr:FAJR")
    readonly property string pr_prayDHUHR: QT_TRID_NOOP("pr:DHUHR")
    readonly property string pr_prayASR: QT_TRID_NOOP("pr:ASR")
    readonly property string pr_prayMAGHRIB: QT_TRID_NOOP("pr:MAGHRIB")
    readonly property string pr_prayISHA: QT_TRID_NOOP("pr:ISHA")
    readonly property string pr_prayerTimes: QT_TRID_NOOP("pr:prayer_times")
    readonly property string pr_serverNotAvailable: QT_TRID_NOOP("pr:server_not_available")

    readonly property string tb_all: QT_TRID_NOOP("tb:all")
    readonly property string tb_info: QT_TRID_NOOP("tb:info")
    readonly property string tb_mapArea: QT_TRID_NOOP("tb:map_area")
    readonly property string tb_places: QT_TRID_NOOP("tb:places")
    readonly property string tb_popular: QT_TRID_NOOP("tb:popular")
    readonly property string tb_tipsByLocal: QT_TRID_NOOP("tb:tips_by_local")
    readonly property string tb_theUltimateGuide: QT_TRID_NOOP("tb:the_ultimate_guide")
    readonly property string tb_whatTheExpertsSay: QT_TRID_NOOP("tb:what_the_experts_say")
    readonly property string tb_whereToNext: QT_TRID_NOOP("tb:where_to_next")

    readonly property string tm_insideMiqat: QT_TRID_NOOP("tm:inside_miqat")
    readonly property string tm_timeToMiqat: QT_TRID_NOOP("tm:time_to_miqat")
    readonly property string tm_distanceToMiqat: QT_TRID_NOOP("tm:distance_to_miqat")
    readonly property string tm_hr: QT_TRID_NOOP("tm:hr")
    readonly property string tm_min: QT_TRID_NOOP("tm:min")
    readonly property string tm_km: QT_TRID_NOOP("tm:km")
    readonly property string tm_miles: QT_TRID_NOOP("tm:miles")

    readonly property string tt_arrival: QT_TRID_NOOP("tt:arrival")
    readonly property string tt_distance: QT_TRID_NOOP("tt:distance")
    readonly property string tt_flightPreviewTips: QT_TRID_NOOP("tt:flight_preview_tips")
    readonly property string tt_landingIn: QT_TRID_NOOP("tt:landing_in_frt")
    readonly property string tt_time: QT_TRID_NOOP("tt:time")

    readonly property string tu_skip: QT_TRID_NOOP("tu:skip")
    readonly property string tu_next: QT_TRID_NOOP("tu:next")
    readonly property string tu_happyTravels: QT_TRID_NOOP("tu:happy_travels")

    readonly property string vs_aircraft360: QT_TRID_NOOP("vs:aircraft_360_view")
    readonly property string vs_bellyCamera: QT_TRID_NOOP("vs:belly_camera")
    readonly property string vs_pilotCamera: QT_TRID_NOOP("vs:pilot_camera")
    readonly property string vs_tailCamera: QT_TRID_NOOP("vs:tail_camera")
    readonly property string vs_cockpitView: QT_TRID_NOOP("vs:cockpit_view")
    readonly property string vs_flightPreview: QT_TRID_NOOP("vs:flight_preview_view")
    readonly property string vs_freeRoaming: QT_TRID_NOOP("vs:free_roaming_view")
    readonly property string vs_groundFlights: QT_TRID_NOOP("vs:ground_flights_view")
    readonly property string vs_leftWindow: QT_TRID_NOOP("vs:left_window_view")
    readonly property string vs_nightView: QT_TRID_NOOP("vs:night_view")
    readonly property string vs_rightWindow: QT_TRID_NOOP("vs:right_window_view")
    readonly property string vs_routeView: QT_TRID_NOOP("vs:route_view")
    readonly property string vs_threeQuartes: QT_TRID_NOOP("vs:three_quarters_view")

    readonly property string vs_apps: QT_TRID_NOOP("vs:apps")
    readonly property string vs_views: QT_TRID_NOOP("vs:views")

    readonly property string vs_aboutPage: QT_TRID_NOOP("vs:about_page")
    readonly property string vs_availableAbove10k: QT_TRID_NOOP("vs:available_above_10k")
    readonly property string vs_airlineRouteMap: QT_TRID_NOOP("vs:airline_route_map")
    readonly property string vs_autoplay: QT_TRID_NOOP("vs:autoplay")
    readonly property string vs_connectingGates: QT_TRID_NOOP("vs:connecting_gates")
    readonly property string vs_distanceDirection: QT_TRID_NOOP("vs:distance_direction")
    readonly property string vs_destinationGuide: QT_TRID_NOOP("vs:destination_guide")
    readonly property string vs_externalLink: QT_TRID_NOOP("vs:external_link")
    readonly property string vs_favoriteCustomLocations: QT_TRID_NOOP("vs:favorite_custom_locations")
    readonly property string vs_flightInformation: QT_TRID_NOOP("vs:flight_information")
    readonly property string vs_geoObjects: QT_TRID_NOOP("vs:geo_objects")
    readonly property string vs_locationPointer: QT_TRID_NOOP("vs:location_pointer")
    readonly property string vs_meccaPointer: QT_TRID_NOOP("vs:mecca_pointer")
    readonly property string vs_mirroring: QT_TRID_NOOP("vs:mirroring")
    readonly property string vs_prayerRoom: QT_TRID_NOOP("vs:prayer_times")
    readonly property string vs_streetMaps: QT_TRID_NOOP("vs:street_maps")
    readonly property string vs_tripBits: QT_TRID_NOOP("vs:trip_bits")
    readonly property string vs_tutorial: QT_TRID_NOOP("vs:tutorial")
    readonly property string vs_worldClock: QT_TRID_NOOP("vs:world_clock")

    readonly property string vs_less: QT_TRID_NOOP("vs:less")
    readonly property string vs_more: QT_TRID_NOOP("vs:more")

    readonly property string wc_12h: QT_TRID_NOOP("wc:12h")
    readonly property string wc_24h: QT_TRID_NOOP("wc:24h")

    property var __directionLabels: [
        generic_ne, // ( 22.5,  67.5]
        generic_e,  // ( 67.5, 112.5]
        generic_se, // (112.5, 157.5]
        generic_s,  // (157.5, 202.5]
        generic_sw, // (202.5, 247.5]
        generic_w,  // (247.5, 292.5]
        generic_nw, // (292.5, 337.5]
        generic_n   // (337.5,  22.5]
    ]

    function directionLabel(direction) {
        console.assert(typeof(direction) === 'number',
                       '"direction" argument must be a "number"');

        var nIndex = Math.floor(((direction - 22.5 + 360) % 360) / 45);
        console.assert(nIndex > -1 && nIndex < __directionLabels.length,
                       "%1 not in [0, %2]".arg(nIndex).arg(__directionLabels.length));

        return App.resources.strings[__directionLabels[nIndex]];
    }
}
