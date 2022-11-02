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
    id: drawRect
    visible: false
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    height: 50
    width: 50
    color: "grey"
    opacity: 0.9
    radius: 20

    Image {
        anchors.fill: parent
        source: "qrc:/images/document-edit.png"
    }

    MouseArea {
        id: drawRectArea
        anchors.fill: parent
        onPressed: drawButtonPressed()
    }
}
