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

Canvas {
    id: canvas
    anchors {
        left: parent.left
        bottom: parent.bottom
    }
    width: i.width
    height: i.height
    scale: i.scale
    property real lastX
    property real lastY
    property color color: window.color

    onPaint: {
        if (stateMachine.drawStateActive) {
            var ctx = getContext('2d')
            ctx.lineWidth = window.size
            ctx.strokeStyle = canvas.color
            ctx.beginPath()
            ctx.moveTo(lastX, lastY)
            lastX = canvasMouseArea.mouseX
            lastY = canvasMouseArea.mouseY
            ctx.lineTo(lastX, lastY)
            ctx.stroke()
        }
    }
}
