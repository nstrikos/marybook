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

Rectangle {
    id: toolRect
    visible: false
    anchors.left: drawRect.right
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 50
    color: "grey"
    opacity: 0.9
    radius: 20

    Rectangle {
        id: blueButton
        width: 50
        height: 50
        anchors.left: parent.left
        anchors.leftMargin: 100
        anchors.bottom: parent.bottom
        color: "blue"
        radius: 20

        MouseArea {
            anchors.fill: parent
            onPressed: {
                window.color = "blue"
                drawRect.border.color = window.color
            }
        }
    }

    Rectangle {
        id: greenButton
        width: 50
        height: 50
        anchors.left: blueButton.right
        anchors.leftMargin: 25
        anchors.bottom: parent.bottom
        color: "green"
        radius: 20

        MouseArea {
            anchors.fill: parent
            onPressed: {
                window.color = "green"
                drawRect.border.color = window.color
            }
        }
    }

    Rectangle {
        id: yellowButton
        width: 50
        height: 50
        anchors.left: greenButton.right
        anchors.leftMargin: 25
        anchors.bottom: parent.bottom
        color: "yellow"
        radius: 20

        MouseArea {
            anchors.fill: parent
            onPressed: {
                window.color = "yellow"
                drawRect.border.color = window.color
            }
        }
    }

    Rectangle {
        id: redButton
        width: 50
        height: 50
        anchors.left: yellowButton.right
        anchors.leftMargin: 25
        anchors.bottom: parent.bottom
        color: "red"
        radius: 20

        MouseArea {
            anchors.fill: parent
            onPressed: {
                window.color = "red"
                drawRect.border.color = window.color
            }
        }
    }

    Image {
        id: colorButton
        width: 50
        height: 50
        anchors.left: redButton.right
        anchors.leftMargin: 25
        anchors.bottom: parent.bottom
        source: "qrc:/images/color-management.png"

        MouseArea {
            anchors.fill: parent
            onPressed: colorDialog.visible = true
        }

        ColorDialog {
            id: colorDialog
            title: "Please choose a color"
            visible: false
            onAccepted: {
                window.color = colorDialog.color
                drawRect.border.color = window.color
            }
        }
    }

    Slider {
        id: sizeSlider
        width: 200
        height: 50
        anchors.left: colorButton.right
        anchors.leftMargin: 25
        anchors.bottom: parent.bottom
        minimumValue: 1
        maximumValue: 25
        stepSize: 1
        value: 5
        onValueChanged: window.size = value
    }

    Label {
        id: sizeLabel
        width: 50
        height: 50
        anchors.left: sizeSlider.right
        anchors.leftMargin: 15
        anchors.bottom: parent.bottom
        text: sizeSlider.value
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Image {
        id: clearButton
        width: 50
        height: 50
        anchors.left: sizeLabel.right
        anchors.leftMargin: 25
        anchors.bottom: parent.bottom
        source: "qrc:/images/edit-reset.png"
        visible: !window.canvasClear

        MouseArea {
            anchors.fill: parent
            onPressed: {
                var ctx = flickable.canvas.getContext('2d')
                ctx.clearRect(0, 0, flickable.canvas.width, flickable.canvas.height);
                flickable.canvas.requestPaint()
                window.canvasClear = true
            }
        }
    }
}
