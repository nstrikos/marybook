import QtQuick 2.15
import QtQuick.Window 2.15

import Qt.labs.platform 1.1

import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QtQuick.Dialogs 1.2

Rectangle {
    anchors.top: page.bottom
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right

    function setText(text) {
        textEdit.text = text
    }

    FileDialog {
        id: saveFileDialog
        selectExisting: false
        nameFilters: ["Text files (*.txt)", "All files (*)"]
        onAccepted: fileExplorer.write(fileUrl, textEdit.text)
    }

    Image {
        id: saveButton
        anchors.top: parent.top
        anchors.left: parent.left
        width: 50
        height: 50
        source: "qrc:/images/document-save.png"
        MouseArea {
            anchors.fill: parent
            onPressed: saveFileDialog.open()
        }
    }

    Image {
        id: decButton
        anchors.top: parent.top
        anchors.left: saveButton.right
        anchors.leftMargin: 25
        width: 50
        height: 50
        source: "qrc:/images/go-down.png"
        MouseArea {
            anchors.fill: parent
            onPressed: textEdit.font.pointSize--
        }
    }

    Image {
        id: incButton
        anchors.top: parent.top
        anchors.left: decButton.right
        anchors.leftMargin: 25
        width: 50
        height: 50
        source: "qrc:/images/go-up.png"
        MouseArea {
            anchors.fill: parent
            onPressed: textEdit.font.pointSize++
        }
    }

    TextArea {
        id: textEdit
        //        anchors.fill: parent
        anchors.top: saveButton.bottom
        anchors.topMargin: 25
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        text:""
    }
}
