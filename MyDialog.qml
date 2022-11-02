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
    id: dialog
    width: 500
    height: 90
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    visible: false

    TextField {
        id: textField
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 30
        text: "New name:"
        readOnly: true
    }

    TextField {
        id: textInput
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: textField.bottom
        height: 30
    }

    Button {
        anchors.top: textInput.bottom
        anchors.right: parent.right
        height: 30
        text: "Ok"
        onClicked: {
            dialog.visible = false
            var oldName = dir + file + ext
            var newName = dir + textInput.text + ext
            fileExplorer.rename(oldName, newName)
            file = textInput.text
        }
    }

    Button {
        text: "Cancel"
        anchors.top: textInput.bottom
        anchors.left: parent.left
        height: 30
        onClicked: {
            textInput.text = ""
            dialog.visible = false
        }
    }

    onVisibleChanged: {
        if (visible) {
            textInput.text = file
        }
    }
}
