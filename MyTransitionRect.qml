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
    id: transitionRect
    visible: true
    anchors.right: parent.right
    anchors.top: parent.top
    height: 50
    width: 50
    color: "grey"
    opacity: 0.5
    z: 11

    Image {
        id: transitionImage
        anchors.fill: parent
        source: "qrc:/images/file-zoom-out.png"
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            if (window.visibility == Window.FullScreen) {
                //window.visibility = Window.Maximized
                window.showMaximized()
                window.width = Screen.desktopAvailableWidth
                window.height = Screen.desktopAvailableHeight
                window.x = 0
                window.y = 0
                transitionImage.source = "qrc:/images/file-zoom-in.png"
            }
            else if (window.visibility != Window.FullScreen) {
                //window.visibility = Window.FullScreen
                window.showFullScreen()
                transitionImage.source = "qrc:/images/file-zoom-out.png"
            }
        }
    }
}
