import QtQuick 2.6
import "./"

StyledTextItem {
    id: root

    property FontMetrics fontMetrics: Utils.fontMetrics(textText.font)

    implicitWidth: fontMetrics.tightBoundingRect(textText.text).width
                   + textText.anchors.leftMargin
                   + textText.anchors.rightMargin
    implicitHeight: fontMetrics.height
                    + textText.bottomPadding
                    + textText.topPadding
    baselineOffset: fontMetrics.ascent
                    + textText.topPadding
}
