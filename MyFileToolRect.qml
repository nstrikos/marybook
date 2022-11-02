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
    id: fileToolRect
    visible: false
    anchors.left: parent.left
    anchors.right: fileRect.left
    anchors.bottom: parent.bottom
    height: 50
    color: "grey"
    opacity: 0.9
    radius: 20

    Image {
        id: fileRenameButton
        width: 50
        height: 50
        anchors.left: parent.left
        anchors.leftMargin: 100
        anchors.bottom: parent.bottom
        source: "qrc:/images/check_constraint.png"

        MouseArea {
            anchors.fill: parent
            onPressed: {
                dialog.visible = true
            }
        }


    }

    Image {
        id: fileRemoveButton
        width: 50
        height: 50
        anchors.left: fileRenameButton.right
        anchors.leftMargin: 25
        anchors.bottom: parent.bottom
        source: "qrc:/images/delete.png"

        MessageDialog {
            id: messageDialog
            title: "Remove file"
            text: "Do you really want to remove file?"
            standardButtons: StandardButton.Ok | StandardButton.Cancel
            onAccepted: {
                var filename = dir + file + ext
                fileExplorer.removeFile(filename)
            }
            visible: false
        }

        MouseArea {
            anchors.fill: parent
            onPressed: messageDialog.visible = true
        }
    }
}
