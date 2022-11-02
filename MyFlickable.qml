import QtQuick 2.15
import QtQuick.Window 2.15

import Qt.labs.platform 1.1

import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.3

import Qt.labs.settings 1.0

import QtQml.StateMachine 1.0 as DSM

import "SplitViewFunctions.js" as Functions

Flickable {
    id: flickable

    property alias canvasMouseArea: canvasMouseArea
    property alias canvas: canvas
    property alias image: i
    property alias iContainer: iContainer

    anchors.fill: parent
    boundsBehavior: Flickable.StopAtBounds
    contentHeight: iContainer.height;
    contentWidth: iContainer.width;
    clip: true

    property bool fitToScreenActive: true

    property real minZoom: 0.1;
    property real maxZoom: 4

    property real zoomStep: 0.05

    onWidthChanged: {
        if (fitToScreenActive)
            fitToScreen();
    }
    onHeightChanged: {
        if (fitToScreenActive)
            fitToScreen();
    }

    Item {
        id: iContainer
        width: Math.max(i.width * i.scale, flickable.width)
        height: Math.max(i.height * i.scale, flickable.height)

        Image {
            id: i

            property real prevScale: 1.0;

            asynchronous: true
            cache: false
            smooth: true
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            transformOrigin: Item.Center
            onScaleChanged: {
                if ((width * scale) > flickable.width) {
                    var xoff = (flickable.width / 2 + f.contentX) * scale / prevScale;
                    f.contentX = xoff - f.width / 2
                }
                if ((height * scale) > flickable.height) {
                    var yoff = (flickable.height / 2 + flickable.contentY) * scale / prevScale;
                    flickable.contentY = yoff - flickable.height / 2
                }
                prevScale=scale;
            }
            onStatusChanged: {
                if (status===Image.Ready) {
                    flickable.fitToScreen();
                }
            }

            MyCanvas {
                id: canvas
            }

            PinchArea {
                anchors.fill: parent
                pinch.target: i
                pinch.minimumScale: 0.1
                pinch.maximumScale: 10

                MouseArea {
                    id: canvasMouseArea
                    preventStealing: false

                    anchors.fill: parent
                    onWheel: {
                        if (wheel.angleDelta.y > 0)
                            flickable.zoomIn()
                        else
                            flickable.zoomOut()
                    }
                    onPressed: {
                        if (stateMachine.drawStateActive) {
                            canvas.lastX = mouseX
                            canvas.lastY = mouseY
                            canvasClear = false
                        }
                        mouseAreaPressed()
                    }
                    onPositionChanged: {
                        if (stateMachine.drawStateActive)
                            canvas.requestPaint()
                    }
                }
            }
        }
    }

    function fitToScreen() {
        zoomFull()
        var s = Math.min(flickable.width / i.width, flickable.height / i.height, 1)
        i.scale = s;
        flickable.minZoom = s;
        i.prevScale = scale
    }
    function zoomIn() {
        i.scale *=(1.0+zoomStep)
    }
    function zoomOut() {
        i.scale *=(1.0-zoomStep)
    }
    function zoomFull() {
        i.scale=1;
        canvas.scale = 1;
        fitToScreenActive=false;
        flickable.returnToBounds();
    }

    ScrollIndicator.vertical: ScrollIndicator { }
    ScrollIndicator.horizontal: ScrollIndicator { }

}
