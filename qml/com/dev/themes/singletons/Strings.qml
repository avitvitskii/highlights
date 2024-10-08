pragma Singleton

import QtQml 2.2

QtObject {
    id: root

    readonly property alias primaryFontCapitalization: __p.primaryFontCapitalization
    readonly property alias primaryFontFamily: __p.primaryFontFamily

    readonly property string fontStyleBold: __p.hasBoldFontStyles ? __p.fontStyleBold : __p.fontStyleRegular
    readonly property string fontStyleBoldCondensed: __p.condensed(fontStyleBold)
    readonly property string fontStyleExtraLight: __p.hasExtraLightFontStyles ? __p.fontStyleExtraLight : __p.fontStyleRegular
    readonly property string fontStyleExtraLightCondensed: __p.condensed(fontStyleExtraLight)
    readonly property string fontStyleLight: __p.hasLightFontStyles ? __p.fontStyleLight : __p.fontStyleRegular
    readonly property string fontStyleLightCondensed: __p.condensed(fontStyleLight)
    readonly property string fontStyleMedium: __p.hasMediumFontStyles ? __p.fontStyleMedium : __p.fontStyleRegular
    readonly property string fontStyleMediumCondensed: __p.condensed(fontStyleMedium)
    readonly property string fontStyleSemiBold: __p.hasSemiBoldFontStyles ? __p.fontStyleSemiBold : __p.fontStyleRegular
    readonly property string fontStyleSemiBoldCondensed: __p.condensed(fontStyleSemiBold)

    readonly property QtObject __private: QtObject {
        id: __p

        property string primaryFontCapitalization: "MixedCase"
        property string primaryFontFamily: "Noto Sans"

        property bool hasBoldFontStyles: true
        property bool hasExtraLightFontStyles: true
        property bool hasLightFontStyles: true
        property bool hasMediumFontStyles: true
        property bool hasSemiBoldFontStyles: true
        property bool hasCondensedFontStyles: true
        readonly property string fontStyleRegular: "Regular"
        readonly property string fontStyleBold:  "Bold"
        readonly property string fontStyleExtraLight: "Extra Light"
        readonly property string fontStyleLight: "Light"
        readonly property string fontStyleMedium: "Medium"
        readonly property string fontStyleSemiBold: "Semi Bold"
        readonly property string fontStyleBoldCondensed:  "Bold Condensed"
        readonly property string fontStyleExtraLightCondensed: "Extra Light Condensed"
        readonly property string fontStyleLightCondensed: "Light Condensed"
        readonly property string fontStyleMediumCondensed: "Medium Condensed"
        readonly property string fontStyleSemiBoldCondensed: "Semi Bold Condensed"

        function condensed(fontStyleName) {
            if (!hasCondensedFontStyles) {
                return fontStyleName;
            }

            return "%1%2".arg(fontStyleName).arg(" Condensed");
        }
    }
}
