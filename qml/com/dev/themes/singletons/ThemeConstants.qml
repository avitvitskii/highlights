pragma Singleton

import QtQuick 2.6

QtObject {
    id: root

    readonly property QtObject colors: QtObject {
        readonly property color primaryColor: "#ff4bc9ff"
        readonly property color primaryTextColor: "#ffffffff"
        readonly property color secondaryTextColor: "#ff2F2F47"
        readonly property color highlightColor: "white"
        readonly property color secondaryColor: "#ff44b5e6"
        readonly property color secondaryBackGroundColor: "#ff08162a"
        readonly property color overlayBackgroundColor: "#ff101821"
        readonly property color gray_1: "#ff676b72"
        readonly property color gray_2: "#ff717884"
        readonly property color gray_3: "#ff2E323C"
        readonly property Gradient tongueGradient: Gradient {
            GradientStop {
                color: "#ff181E27"
                position: 0.0
            }
            GradientStop {
                color: "#ff202631"
                position: 1.0
            }
        }
        readonly property Gradient primaryGradient: Gradient {
            GradientStop {
                color: "#ff070a0f"
                position: 0.0
            }
            GradientStop {
                color: "#ff333b4c"
                position: 1.0
            }
        }
        readonly property Gradient primaryGradientFlipped: Gradient {
            GradientStop {
                color: "#ff333b4c"
                position: 0.0
            }
            GradientStop {
                color: "#ff070a0f"
                position: 1.0
            }
        }
        readonly property Gradient viewDelegateGradient: Gradient {
            GradientStop {
                color: "white"
                position: 0.0
            }
            GradientStop {
                color: "#ff808080"
                position: 1.0
            }
        }
        readonly property Gradient viewDelegateCheckedGradient: Gradient {
            GradientStop {
                color: "#ff26b0ec"
                position: 0.0
            }
            GradientStop {
                color: "#ff156282"
                position: 1.0
            }
        }
    }
    readonly property QtObject featureIds: QtObject {
        /*! About page feature id. Value: "about-page". */
        readonly property string aboutPage: "about-page"
        /*! Route map feature id. Value: "airline-route-map". */
        readonly property string airlineRouteMap: "airline-route-map"
        /*! Autoplay feature id. Value: "autoplay". */
        readonly property string autoplay: "autoplay"
        /*! Close (back) feature id. Value: "close". */
        readonly property string close: "close"
        /*! Connecting gates feature id. Value: "connecting-gates". */
        readonly property string connectingGates: "connecting-gates"
        /*! Custom script feature id. Value: "custom-script". */
        readonly property string customScript: "custom-script"
        /*! Custom page feature id. Value: "custom-page". */
        readonly property string customPage: "custom-page"
        /*! Distance and direction indicator feature id. Value: "distance-direction-indicator". */
        readonly property string ddi: "distance-direction-indicator"
        /*! Destination guide feature id. Value: "destination-guide". */
        readonly property string destinationGuide: "destination-guide"
        /*! Exit feature id. Value: "exit". */
        readonly property string exit: "exit"
        /*! Expander (more/less on Apps&Views) feature id. Value: "expander". */
        readonly property string expander: "expander"
        /*! External link feature id. Value: "external-link". */
        readonly property string externalLink: "external-link"
        /*! Flight information feature id. Value: "flight-information". */
        readonly property string flightInformation: "flight-information"
        /*! Geo objects (flying over places) feature id. Value: "geo-objects". */
        readonly property string geoObjects: "geo-objects"
        /*! Ground Flights (based on geo objects)*/
        readonly property string groundFlights: "ground_flights"
        /*! Highlights feature id. Value: "highlights". */
        readonly property string highlights: "highlights"
        /*! Image page feature id. Value: "image-page". */
        readonly property string imagePage: "image-page"
        /*! Location pointer feature id. Value: "location-pointer". */
        readonly property string locationPointer: "location-pointer"
        /*! Mecca pointer feature id. Value: "mecca-pointer". */
        readonly property string meccaPointer: "mecca-pointer"
        /*! Miqat widget feature id. Value: "miqat-widget". */
        readonly property string miqatWidget: "miqat-widget"
        /*! Mirroring feature id. Value: "mirroring". */
        readonly property string mirroring: "mirroring"
        /*! Prayer room feature id. Value: "prayer-room". */
        readonly property string prayerRoom: "prayer-room"
        /*! Sattelite coverage view feature id. Value: "satellite-coverage". */
        readonly property string satelliteCoverage: "satellite-coverage"
        /*! Street maps feature id. Value: "street-map". */
        readonly property string streetMap: "street-map"
        /*! Trip bits feature id. Value: "tripbits". */
        readonly property string tripBits: "tripbits"
        /*! View selector feature id. Value: "views". */
        readonly property string views: "views"
        /*! World clock feature id. Value: "world-clock". */
        readonly property string worldClock: "world-clock"
        /*! Favorite custom locations feature id. Value: "favorite-custom-locations". */
        readonly property string fcl: "favorite-custom-locations"
        /*! Time to miqat feature id. Value: "time-to-miqat". */
        readonly property string timeToMiqat: "time-to-miqat"
        /*! Tutorial feature id. Value: "tutorial". */
        readonly property string tutorial: "tutorial"
    }

    readonly property QtObject viewStateIds: QtObject {
        readonly property string groundFlights: featureIds.groundFlights
    }

    property real transitionSpeed: 150
}
