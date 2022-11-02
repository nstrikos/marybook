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

SplitView {
    anchors.fill: parent
    orientation: Qt.Horizontal

    property alias iContainer: page.iContainer
    property alias image: page.image

    property bool mousePressed: false

    FileBrowser {
        id: fileBrowser
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        property int minimumWidth: parent.width * 1 / 4

        Layout.minimumWidth: minimumWidth
        Layout.maximumWidth: parent.width * 3 / 4
    }

    SplitView {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: fileBrowser.right
        anchors.right: parent.right
        orientation: Qt.Vertical

        MyPage {
            id: page
        }

        TextBook {
            id: textBook

            function openText(source) {
                page.height = window.height - 250
                //setText(source)
                setText(fileExplorer.read(source))
            }
        }

    }

    Component.onCompleted: {
        fileBrowser.folder = StandardPaths.writableLocation(StandardPaths.PicturesLocation) //"/home/nick/"
        fileBrowser.show()
    }

    Connections {
        target: fileBrowser
        function onFileSelected(source) {
            var s = page.extension(source)
            if (s === ".txt")
                textBook.openText(source)
            else if (!canvasClear) {
                canvasClear = true
                var filename = window.dir + window.file + "-annotated.png"
                iContainer.visible = false
                i.scale = 1
                iContainer.grabToImage(function(result) {
                    result.saveToFile(filename);
                    fileExplorer.makeBackup(window.dir, window.file + window.ext)
                    page.updateImage(source)
                    iContainer.visible = true
                });
            } else {
                page.updateImage(source)
            }
        }
    }

    function enterInitialState() {
        Functions.enterInitialState()
    }

    function enterShowToolState() {
        Functions.enterShowToolState()
    }

    function enterDrawState() {
        Functions.enterDrawState()
    }

    function enterFileState() {
        Functions.enterFileState()
    }
}
