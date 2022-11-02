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
    id: textRect

    anchors.bottom: parent.bottom
    anchors.right: parent.right
    color: "grey"
    height: 50
    opacity: 0.5
    radius: 20
    visible: true
    width: 50
    z: 11

    Image {
        anchors.fill: parent
        source: "qrc:/images/tool_pagelayout.png"
    }

    MouseArea {
        id: textRectArea
        anchors.fill: parent
        onPressed: {
            if (page.height < window.height) {
                page.height = window.height
                textRect.border.color = "transparent"
                textRect.border.width = 0
            }
            else {
                page.height = window.height - 250
                textRect.border.color = window.color
                textRect.border.width = 8
            }
        }
    }
}
