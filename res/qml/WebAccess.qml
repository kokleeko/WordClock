import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebView 1.15

import "qrc:/js/Helpers.js" as Helpers

Drawer {
    id: popup
    property alias webView: webView
    edge: Qt.RightEdge
    width: parent.width
    height: parent.height
    interactive: opened
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        ToolBar {
            Layout.fillWidth: true
            RowLayout {
                anchors.fill: parent
                ToolButton {
                    icon.source: "qrc:/assets/circle-xmark-solid.svg"
                    onClicked: popup.close()
                }
                ToolSeparator { }
                ToolButton {
                    icon.source: "qrc:/assets/arrow-left-solid.svg"
                    onClicked: webView.openUrl(webView.baseUrl, true)
                }
                ToolButton {
                    icon.source: "qrc:/assets/arrow-rotate-right-solid.svg"
                    onClicked: webView.reload()
                }
                Label {
                    text: webView.title
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    font.bold: true
                }
                ToolButton {
                    icon.source: "qrc:/assets/share-from-square-solid.svg"
                    onClicked: Qt.openUrlExternally(webView.baseUrl)
                }
            }
        }
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            WebView {
                id: webView
                function openUrl(url, fromBack = false) {
                    if (url !== baseUrl)
                        webView.url = url
                    if (!fromBack) {
                        popup.open()
                        baseUrl = url
                    }
                }
                property string title
                property string baseUrl
                property int status
                property string errorString
                visible: status === WebView.LoadSucceededStatus
                anchors.fill: parent
                onLoadingChanged: {
                    status = loadRequest.status
                    switch (status) {
                    case WebView.LoadStartedStatus:
                        webView.title = qsTr("Loading...")
                        break;
                    case WebView.LoadSucceededStatus:
                        runJavaScript("document.title", (title) => webView.title = title)
                        break;
                    case WebView.LoadFailedStatus:
                        webView.title = qsTr("Houston, we have a problem")
                        webView.errorString = loadRequest.errorString
                        break;
                    }
                }
            }
            BusyIndicator {
                anchors.centerIn: parent
                visible: webView.status === WebView.LoadStartedStatus
                running: visible
            }
            Rectangle {
                id: errorPage
                anchors.fill: parent
                visible: webView.status === WebView.LoadFailedStatus
                color: palette.button
                Label {
                    anchors { fill: parent; margins: parent.width/4 }
                    text: webView.errorString
                    font.pointSize: headings.h1
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                    wrapMode: Label.WordWrap
                    maximumLineCount: 10
                    style: Label.Raised
                    styleColor: palette.base
                }
            }
        }
    }
}