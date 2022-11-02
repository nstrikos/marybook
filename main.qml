import QtQuick 2.15
import QtQuick.Window 2.15

import Qt.labs.platform 1.1

import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.3

import Qt.labs.settings 1.0

import QtQml.StateMachine 1.0 as DSM

ApplicationWindow {
    id: window
    width: Screen.width
    height: Screen.height
    x: 200
    y: 200
    visible: true
    title: qsTr("Mary book")

    property int appState: 1
    property bool canvasClear: true
    property color color: "blue"
    property int size: 5
    property string file: ""
    property string ext: ""
    property string dir: ""

    signal mouseAreaPressed
    signal drawButtonPressed
    signal fileButtonPressed
    signal updatePage

    Settings {
        property alias color: window.color
    }

    StateMachine {
        id: stateMachine
    }

    property int screenWidth: 0
    property int screenHeight: 0


    property int pixDens: Math.ceil(Screen.pixelDensity)
    property int itemWidth: 25 * pixDens
    property int itemHeight: 10 * pixDens
    property int scaledMargin: 2 * pixDens
    property int fontSize:  Qt.platform.os == "android" ?  (2 * pixDens) : (5 * pixDens)

    MySplitView {
        id: mySplitView
    }

    Shortcut {
        sequence: "Esc"
        context: Qt.ApplicationShortcut
        onActivated: {
            window.close()
        }
    }

    onClosing: {
        if (!canvasClear) {
            close.accepted = false
        }

        if (!canvasClear) {
            canvasClear = true
            var filename = window.dir + window.file + "-annotated.png"
            mySplitView.iContainer.visible = false
            mySplitView.image.scale = 1
            mySplitView.iContainer.grabToImage(function(result) {
                result.saveToFile(filename);
                fileExplorer.makeBackup(window.dir, window.file + window.ext)
                window.close()
            });
        }
    }
}
