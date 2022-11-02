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
    id: nextRect
    visible: false
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    height: 100
    width: 100
    color: "grey"
    opacity: 0.5

    Image {
        anchors.fill: parent
        source: "qrc:/images/left-arrow.png"
        transformOrigin: Item.Center
        rotation: 180
    }

    MouseArea {
        id: nextMouseArea
        anchors.fill: parent
        onPressed: {
            fileBrowser.next()
        }
    }
}
