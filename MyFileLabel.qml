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

Label {
    id: fileLabel
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    font.bold: true
    font.pixelSize: 22
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: file
}
