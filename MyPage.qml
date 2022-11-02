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

Page {
    id: page

    property alias transitionRect: transitionRect
    property alias previousRect: previousRect
    property alias nextRect: nextRect
    property alias fullScreenRect: fullScreenRect
    property alias fitZoomRect: fitZoomRect
    property alias fitScreenRect: fitScreenRect
    property alias zoomInRect: zoomInRect
    property alias zoomOutRect: zoomOutRect
    property alias drawRect: drawRect
    property alias toolRect: toolRect
    property alias fileRect: fileRect
    property alias fileLabel: fileLabel
    property alias fileToolRect: fileToolRect
    property alias textRect: textRect
    property alias canvasMouseArea: flickable.canvasMouseArea
    property alias iContainer: flickable.iContainer
    property alias image: flickable.image

    anchors.top: parent.top
    //            anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: parent.height

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.5
    }

    MyFlickable {
        id: flickable
    }

    MyTransitionRect {
        id: transitionRect
    }

    MyPreviousRect {
        id: previousRect
    }

    MyNextRect {
        id: nextRect
    }

    MyFullScreenRect {
        id: fullScreenRect
    }

    MyFitZoomRect {
        id: fitZoomRect
    }

    MyFitScreenRect {
        id: fitScreenRect
    }

    MyZoomInRect {
        id: zoomInRect
    }

    MyZoomOutRect {
        id: zoomOutRect
    }

    MyFileLabel {
        id: fileLabel
    }

    MyDrawRect {
        id: drawRect
    }

    MyToolRect {
        id: toolRect
    }

    MyFileRect {
        id: fileRect
    }

    MyFileToolRect {
        id: fileToolRect
    }

    MyDialog {
        id: dialog
    }

    MyTextRect {
        id: textRect

    }

    Image {
        id: image
        //                    anchors.fill: parent
        //source: "qrc:/images/wp4064878-old-paper-wallpapers.jpg"
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        anchors.left: parent.left
        anchors.right: parent.right
        z: 1

        MouseArea {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            preventStealing: false
            propagateComposedEvents: true
            onPressed: {
                mouse.accepted = false
                mousePressed = false
                mouseAreaPressed()
                mousePressed = true
            }
        }
    }

    function updateImage(source) {
        image.source = ""
        var ctx = flickable.canvas.getContext('2d')
        ctx.clearRect(0, 0, flickable.canvas.width, flickable.canvas.height);
        canvasClear = true
        updatePage()
        flickable.image.source = source
        file = basename(source)
        ext = extension(source)
        dir = directory(source)
    }

    function basename(str)
    {
        var s = (str.slice(str.lastIndexOf("/")+1))
        var f = s.indexOf(".")
        return s.substring(0, f)
    }

    function extension(str)
    {
        var s = (str.slice(str.lastIndexOf("/")+1))
        var f = s.indexOf(".")
        return s.slice(f)
    }

    function directory(str) {
        var s = str.replace("file://", "")
        var f = s.lastIndexOf("/") + 1
        return s.substring(0, f)
    }

}
