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

        Page {
            id: page
            anchors.top: parent.top
            //            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height

            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.5
            }

            Flickable {
                id: f
                anchors.fill: parent
                boundsBehavior: Flickable.StopAtBounds
                contentHeight: iContainer.height;
                contentWidth: iContainer.width;
                clip: true

                property bool fitToScreenActive: true

                property real minZoom: 0.1;
                property real maxZoom: 4

                property real zoomStep: 0.05

                onWidthChanged: {
                    if (fitToScreenActive)
                        fitToScreen();
                }
                onHeightChanged: {
                    if (fitToScreenActive)
                        fitToScreen();
                }

                Item {
                    id: iContainer
                    width: Math.max(i.width * i.scale, f.width)
                    height: Math.max(i.height * i.scale, f.height)

                    Image {
                        id: i

                        property real prevScale: 1.0;

                        asynchronous: true
                        cache: false
                        smooth: true
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit
                        transformOrigin: Item.Center
                        onScaleChanged: {
                            if ((width * scale) > f.width) {
                                var xoff = (f.width / 2 + f.contentX) * scale / prevScale;
                                f.contentX = xoff - f.width / 2
                            }
                            if ((height * scale) > f.height) {
                                var yoff = (f.height / 2 + f.contentY) * scale / prevScale;
                                f.contentY = yoff - f.height / 2
                            }
                            prevScale=scale;
                        }
                        onStatusChanged: {
                            if (status===Image.Ready) {
                                f.fitToScreen();
                            }
                        }

                        Canvas {
                            id: canvas
                            anchors {
                                left: parent.left
                                bottom: parent.bottom
                            }
                            width: i.width
                            height: i.height
                            scale: i.scale
                            property real lastX
                            property real lastY
                            property color color: window.color

                            onPaint: {
                                if (stateMachine.drawStateActive) {
                                    var ctx = getContext('2d')
                                    ctx.lineWidth = window.size
                                    ctx.strokeStyle = canvas.color
                                    ctx.beginPath()
                                    ctx.moveTo(lastX, lastY)
                                    lastX = canvasMouseArea.mouseX
                                    lastY = canvasMouseArea.mouseY
                                    ctx.lineTo(lastX, lastY)
                                    ctx.stroke()
                                }
                            }
                        }

                        PinchArea {
                            anchors.fill: parent
                            pinch.target: i
                            pinch.minimumScale: 0.1
                            pinch.maximumScale: 10

                            MouseArea {
                                id: canvasMouseArea
                                preventStealing: false

                                anchors.fill: parent
                                onWheel: {
                                    if (wheel.angleDelta.y > 0)
                                        f.zoomIn()
                                    else
                                        f.zoomOut()
                                }
                                onPressed: {
                                    if (stateMachine.drawStateActive) {
                                        canvas.lastX = mouseX
                                        canvas.lastY = mouseY
                                        canvasClear = false
                                    }
                                    mouseAreaPressed()
                                }
                                onPositionChanged: {
                                    if (stateMachine.drawStateActive)
                                        canvas.requestPaint()
                                }
                            }
                        }
                    }
                }

                function fitToScreen() {
                    zoomFull()
                    var s = Math.min(f.width / i.width, f.height / i.height, 1)
                    i.scale = s;
                    f.minZoom = s;
                    i.prevScale = scale
                }
                function zoomIn() {
                    i.scale *=(1.0+zoomStep)
                }
                function zoomOut() {
                    i.scale *=(1.0-zoomStep)
                }
                function zoomFull() {
                    i.scale=1;
                    canvas.scale = 1;
                    fitToScreenActive=false;
                    f.returnToBounds();
                }

                ScrollIndicator.vertical: ScrollIndicator { }
                ScrollIndicator.horizontal: ScrollIndicator { }

            }

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

            Rectangle {
                id: previousRect
                visible: false
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                height: 100
                width: 100
                color: "grey"
                opacity: 0.5

                Image {
                    anchors.fill: parent
                    source: "qrc:/images/left-arrow.png"
                }

                MouseArea {
                    id: previousMouseArea
                    anchors.fill: parent
                    onPressed: {
                        fileBrowser.previous()
                    }
                }
            }

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

            Rectangle {
                id: fullScreenRect
                visible: false
                anchors.right: transitionRect.left
                anchors.rightMargin: 25
                anchors.top: parent.top
                height: 50
                width: 50
                color: "grey"
                opacity: 0.5

                Image {
                    id: fullScreenImage
                    anchors.fill: parent
                    source: "qrc:/images/auto-transition-right.png"
                }

                MouseArea {
                    id: fullScreenMouseArea
                    anchors.fill: parent
                    onPressed: {
                        if (appState == 2) {
                            fileBrowser.width = 400
                            fileBrowser.visible = true
                            appState = 1
                        }
                        else {
                            appState = 2
                            fileBrowser.minimumWidth = 0
                            fileBrowser.width = 0
                            fileBrowser.visible = false
                        }
                    }
                }
            }

            Rectangle {
                id: fitZoomRect
                visible: false
                anchors.right: fullScreenRect.left
                anchors.rightMargin: 25
                anchors.top: parent.top
                height: 50
                width: 50
                color: "grey"
                opacity: 0.5

                Image {
                    anchors.fill: parent
                    source: "qrc:/images/zoom-fit-best.png"
                }

                MouseArea {
                    id: fitZoomMouseArea
                    anchors.fill: parent
                    onPressed: {
                        f.zoomFull()
                    }
                }
            }

            Rectangle {
                id: fitScreenRect
                visible: false
                anchors.right: fitZoomRect.left
                anchors.rightMargin: 25
                anchors.top: parent.top
                height: 50
                width: 50
                color: "grey"
                opacity: 0.5

                Image {
                    anchors.fill: parent
                    source: "qrc:/images/zoom-original.png"
                }

                MouseArea {
                    id: fitScreenMouseArea
                    anchors.fill: parent
                    onPressed: {
                        f.fitToScreen()
                    }
                }
            }

            Rectangle {
                id: zoomInRect
                visible: false
                anchors.right: fitScreenRect.left
                anchors.rightMargin: 25
                anchors.top: parent.top
                height: 50
                width: 50
                color: "grey"
                opacity: 0.5

                Image {
                    anchors.fill: parent
                    source: "qrc:/images/zoom-original.png"
                }

                MouseArea {
                    id: zoomInMouseArea
                    anchors.fill: parent
                    onPressed: {
                        f.zoomIn()
                    }
                }
            }

            Rectangle {
                id: zoomOutRect
                visible: false
                anchors.right: zoomInRect.left
                anchors.rightMargin: 25
                anchors.top: parent.top
                height: 50
                width: 50
                color: "grey"
                opacity: 0.5

                Image {
                    anchors.fill: parent
                    source: "qrc:/images/zoom-original.png"
                }

                MouseArea {
                    id: zoomOutMouseArea
                    anchors.fill: parent
                    onPressed: {
                        f.zoomOut()
                    }
                }
            }

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

            Rectangle {
                id: toolRect
                visible: false
                anchors.left: drawRect.right
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 50
                color: "grey"
                opacity: 0.9
                radius: 20

                Rectangle {
                    id: blueButton
                    width: 50
                    height: 50
                    anchors.left: parent.left
                    anchors.leftMargin: 100
                    anchors.bottom: parent.bottom
                    color: "blue"
                    radius: 20

                    MouseArea {
                        anchors.fill: parent
                        onPressed: {
                            window.color = "blue"
                            drawRect.border.color = window.color
                        }
                    }
                }

                Rectangle {
                    id: greenButton
                    width: 50
                    height: 50
                    anchors.left: blueButton.right
                    anchors.leftMargin: 25
                    anchors.bottom: parent.bottom
                    color: "green"
                    radius: 20

                    MouseArea {
                        anchors.fill: parent
                        onPressed: {
                            window.color = "green"
                            drawRect.border.color = window.color
                        }
                    }
                }

                Rectangle {
                    id: yellowButton
                    width: 50
                    height: 50
                    anchors.left: greenButton.right
                    anchors.leftMargin: 25
                    anchors.bottom: parent.bottom
                    color: "yellow"
                    radius: 20

                    MouseArea {
                        anchors.fill: parent
                        onPressed: {
                            window.color = "yellow"
                            drawRect.border.color = window.color
                        }
                    }
                }

                Rectangle {
                    id: redButton
                    width: 50
                    height: 50
                    anchors.left: yellowButton.right
                    anchors.leftMargin: 25
                    anchors.bottom: parent.bottom
                    color: "red"
                    radius: 20

                    MouseArea {
                        anchors.fill: parent
                        onPressed: {
                            window.color = "red"
                            drawRect.border.color = window.color
                        }
                    }
                }

                Image {
                    id: colorButton
                    width: 50
                    height: 50
                    anchors.left: redButton.right
                    anchors.leftMargin: 25
                    anchors.bottom: parent.bottom
                    source: "qrc:/images/color-management.png"

                    MouseArea {
                        anchors.fill: parent
                        onPressed: colorDialog.visible = true
                    }

                    ColorDialog {
                        id: colorDialog
                        title: "Please choose a color"
                        visible: false
                        onAccepted: {
                            window.color = colorDialog.color
                            drawRect.border.color = window.color
                        }
                    }
                }

                Slider {
                    id: sizeSlider
                    width: 200
                    height: 50
                    anchors.left: colorButton.right
                    anchors.leftMargin: 25
                    anchors.bottom: parent.bottom
                    minimumValue: 1
                    maximumValue: 25
                    stepSize: 1
                    value: 5
                    onValueChanged: window.size = value
                }

                Label {
                    id: sizeLabel
                    width: 50
                    height: 50
                    anchors.left: sizeSlider.right
                    anchors.leftMargin: 15
                    anchors.bottom: parent.bottom
                    text: sizeSlider.value
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Image {
                    id: clearButton
                    width: 50
                    height: 50
                    anchors.left: sizeLabel.right
                    anchors.leftMargin: 25
                    anchors.bottom: parent.bottom
                    source: "qrc:/images/edit-reset.png"
                    visible: !window.canvasClear

                    MouseArea {
                        anchors.fill: parent
                        onPressed: {
                            var ctx = canvas.getContext('2d')
                            ctx.clearRect(0, 0, canvas.width, canvas.height);
                            canvas.requestPaint()
                            window.canvasClear = true
                        }
                    }
                }
            }

            Rectangle {
                id: fileRect
                visible: false
                anchors.right: textRect.left
                anchors.rightMargin: 25
                anchors.bottom: parent.bottom
                height: 50
                width: 50
                color: "grey"
                opacity: 0.9
                radius: 20

                Image {
                    anchors.fill: parent
                    source: "qrc:/images/folder-blue.png"
                }

                MouseArea {
                    id: fileRectArea
                    anchors.fill: parent
                    onPressed: fileButtonPressed()
                }
            }

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

            Rectangle {
                id: textRect
                visible: true
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 50
                width: 50
                color: "grey"
                opacity: 0.5
                radius: 20

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

            Image {
                id: image
                //                    anchors.fill: parent
                //source: "qrc:/images/wp4064878-old-paper-wallpapers.jpg"
                anchors.top: parent.top
                anchors.topMargin: 50
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 50
                anchors.left: parent.left
                anchors.right: parent.right
                z: 1

                MouseArea {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    preventStealing: false
                    propagateComposedEvents: true
                    onPressed: {
                        mouse.accepted = false
                        mousePressed = false
                        mouseAreaPressed()
                        mousePressed = true
                    }
                }
            }

            function updateImage(source) {
                image.source = ""
                var ctx = canvas.getContext('2d')
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                canvasClear = true
                updatePage()
                i.source = source
                file = basename(source)
                ext = extension(source)
                dir = directory(source)
            }

            function basename(str)
            {
                var s = (str.slice(str.lastIndexOf("/")+1))
                var f = s.indexOf(".")
                return s.substring(0, f)
            }

            function extension(str)
            {
                var s = (str.slice(str.lastIndexOf("/")+1))
                var f = s.indexOf(".")
                return s.slice(f)
            }

            function directory(str) {
                var s = str.replace("file://", "")
                var f = s.lastIndexOf("/") + 1
                return s.substring(0, f)
            }

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
