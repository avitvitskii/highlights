import QtQuick 2.6

import com.dev.themes.controls 1.0
import com.dev.themes.singletons 1.0

HighlightsLayoutForm {
    id: root

    readonly property var __defaultHighlight: Object.freeze({
        title: "Title",
        image: {
            url: "qrc:///qml/screens/globe/highlights/images/pin.png"
        },
        description: "Some text",
        isGreeting: false
    })
    readonly property var newHighlights: __newHighlights
    readonly property int highlightsLimit: 50
    property var highlightsOnClickedFunctions: ({})
    property int firstInsertLength: 0
    readonly property int visibleCount: 2
    property var visibleHighlightsHeights: []

    signal animationFinished()

    fullHeight: __fullHeight
    buttonClose {
        visible: isWhole
        onClicked: isWhole = false
    }
    buttonFeed {
        visible: !isOpened
        onClicked: isOpened = true
    }
    itemLayout.visible: isOpened
    listView {
        boundsBehavior: ListView.StopAtBounds
        delegate: HighlightsBackground {
            id: delegateContainer

            readonly property var highlight: model || root.__defaultHighlight

            width: Math.min(itemLayout.width, highlightImage.implicitWidth + Math.max(textTitle.textText.contentWidth
                                                                                + textTitle.style.paddings.left
                                                                                + textTitle.style.paddings.right,
                                                                                textDescription.textText.contentWidth
                                                                                + textDescription.style.paddings.left
                                                                                + textDescription.style.paddings.right)
                                                                                + row.leftPadding + row.rightPadding)
            height: Math.max(Dimen._72, Math.max(highlightImage.implicitHeight,
                                                 textTitle.implicitHeight
                                                 + textDescription.textText.contentHeight
                                                 + row.bottomPadding
                                                 + row.topPadding))
            Component.onCompleted: {
                if (!!model.analytics) {
                    logUserActivity({
                        c: "highlights",
                        a: "show",
                        p: model.analytics.payload,
                        t: model.analytics.target,
                    });
                }

                visibleHighlightsHeights.push(delegateContainer.height);
                if (visibleHighlightsHeights.length > visibleCount) {
                   visibleHighlightsHeights.shift();
                }
                var delegateHeight = 0;
                for (var i = 0; i < visibleHighlightsHeights.length; i++) {
                    delegateHeight += visibleHighlightsHeights[i] + listView.spacing;
                }
                mouseAreaSwipeDetector.height = delegateHeight;
            }

            Row {
                id: row

                anchors.fill: parent
                bottomPadding: Dimen._10
                leftPadding: Dimen._16
                rightPadding: leftPadding
                topPadding: bottomPadding
                spacing: Dimen._8

                ColorImage {
                    id: highlightImage

                    anchors.top: highlightBody.top
                    width: Dimen._36
                    height: Math.round(width * sourceSize.height / sourceSize.width)
                    source: !!model && !!model.image && !!model.image.url ? model.image.url : ""
                    sourceScale: Dimen.scalingFactor
                }
                Column {
                    id: highlightBody

                    anchors.verticalCenter: parent.verticalCenter

                    StyledTextItem {
                        id: textTitle

                        width: itemLayout.width - highlightImage.width - row.leftPadding - row.rightPadding - row.spacing
                        text: !!model && !!model.title ? model.title : ""
                        textText {
                            elide: Text.ElideRight
                            maximumLineCount: 2
                        }
                        style {
                            color: "white"
                            font {
                                family: Strings.primaryFontFamily
                                pixelSize: Dimen._32
                                styleName: Strings.fontStyleBold
                            }
                            paddings {
                                left: textMetricsTitle.tightBoundingRect.width > Dimen._32 ? 0 : Dimen._36
                                right: style.paddings.left
                            }
                            wrapMode: Text.WordWrap
                        }
                        visible: !!text
                    }
                    StyledTextItem {
                        id: textDescription

                        width: textTitle.width
                        text: !!model && !!model.description ? model.description : ""
                        textText {
                            elide: Text.ElideRight
                            maximumLineCount: 3
                        }
                        style {
                            color: "white"
                            font {
                                family: Strings.primaryFontFamily
                                pixelSize: Dimen._28
                                styleName: Strings.fontStyleMedium
                            }
                            paddings {
                                left: textMetricsDescription.tightBoundingRect.width > Dimen._28 ? 0 : Dimen._36
                                right: style.paddings.left
                            }
                            wrapMode: Text.WordWrap
                        }
                        visible: !!text
                    }
                    TextMetrics {
                        id: textMetricsTitle

                        font: textTitle.style.font
                        text: textTitle.text
                    }
                    TextMetrics {
                        id: textMetricsDescription

                        font: textDescription.style.font
                        text: textDescription.text
                    }
                }
            }
            MouseArea {
                property var clickHandler

                anchors.fill: parent
                enabled: typeof clickHandler === "function"
                onClicked: {
                    clickHandler();
                    if (!!model.analytics) {
                        logUserActivity({
                            c: "highlights",
                            a: "click",
                            p: model.analytics.payload,
                            t: model.analytics.target,
                        });
                    }
                }
                Component.onCompleted: {
                    if (typeof highlightsOnClickedFunctions[model.functionIndex] === "function") {
                        clickHandler = highlightsOnClickedFunctions[model.functionIndex];
                    }
                }
            }
            Connections {
                target: root
                onAnimationFinished: {
                    if (index > visibleCount - 1) {
                        visible = Qt.binding(function bindingVisible() {
                            return isOpened && isWhole;
                        });
                    }
                }
            }
            Behavior on opacity {
                enabled: state === "movedAndFaded"

                NumberAnimation {
                    duration: 500
                }
            }
            Behavior on y {
                id: behaviorY

                NumberAnimation {
                    duration: 1000
                }
            }

            onStateChanged: {
                if (state === "movedAndFaded") {
                    y = y - 100;
                } else if (root.preloader.visible && index === 1) {
                    behaviorY.enabled = false;
                    y = listView.y - 2 * delegateContainer.height - listView.spacing;
                }
            }
            state: "default"
            states: [
                State {
                    name: "whole open"
                    when: root.state === "whole open"

                    PropertyChanges {
                        target: delegateContainer
                        opacity: 1.0
                    }
                },
                State {
                    name: "movedAndFaded"
                    when: root.preloader.visible && index === 1

                    PropertyChanges {
                        target: delegateContainer
                        opacity: 0
                    }
                },
                State {
                    name: "default"

                    PropertyChanges {
                        target: delegateContainer
                        opacity: 1.0
                    }
                }
            ]
        }
        model: ListModel {
            id: listModel

            dynamicRoles: true
            onCountChanged: {
                if (count > highlightsLimit) {
                    var highlight = get(count - 1);
                    remove(count - 1);
                    delete highlightsOnClickedFunctions[highlight.functionIndex];
                }
            }
        }
        add: Transition {
            enabled: listView.currentIndex < firstInsertLength
            NumberAnimation { properties: "x,y"; duration: 1000 }
            NumberAnimation { property: "opacity"; duration: 1000; from: 0.0; to: 1.0 }
        }
        addDisplaced: Transition {
            SequentialAnimation {
                PropertyAction { properties: "x,y" }
                ScriptAction {
                    script: animationFinished()
                }
            }
        }
    }
    onNewHighlightsChanged: {
        if (listModel.count === 0) {
            firstInsertLength = newHighlights.length;
        }

        var currentIndex = 0;

        function insertNextHighlight() {
            if (currentIndex < newHighlights.length) {
                var highlight = newHighlights[currentIndex];
                var nFunctionIndex = (listModel.count > 0 ? (listModel.get(0).functionIndex + 1) % highlightsLimit : 0);
                highlightsOnClickedFunctions[nFunctionIndex] = highlight.onClicked;
                if (listModel.count >= firstInsertLength) {
                    root.preloader.visible = true;
                    root.preloader.visibleChanged.connect(function onPreloaderHidden() {
                        if (!root.preloader.visible) {
                            root.preloader.visibleChanged.disconnect(onPreloaderHidden);
                            listModel.insert(0, Object.assign(highlight, { functionIndex: nFunctionIndex }));

                            currentIndex++;
                            insertNextHighlight();
                        }
                    });

                    return;
                }

                listModel.insert(0, Object.assign(highlight, { functionIndex: nFunctionIndex }));

                currentIndex++;
                insertNextHighlight();
            }
        }

        insertNextHighlight();
    }
    onStateChanged: {
        switch (state) {
            case "whole open":
                highlightsStore.timerFeedGenerator.stop()
                break;
            case "open":
                highlightsStore.timerFeedGenerator.start()
                break;
            case "close":
            default:
                highlightsStore.timerFeedGenerator.stop()
                break;
        }
    }
    Component.onCompleted: {
        var configurationURIs = "highlights_feed.json";
        if (!!configurationURIs) {
            highlightsStore.setup(configurationURIs, function onConfigureFinished() {
                featuresController.showFeature(ThemeConstants.featureIds.highlights, true, false);
            });
        }
    }
}
