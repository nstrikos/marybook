import QtQuick 2.1
import Qt.labs.folderlistmodel 2.15

Rectangle {
    id: fileBrowser
    color: "black"//"transparent"
    z: 4

    property string folder
    property bool shown: loader.sourceComponent
    property var count
    property string file

    signal fileSelected(string file)

    function selectFile(file, counter) {
        if (file !== "") {
            folder = loader.item.folders.folder
            fileBrowser.fileSelected(file)
            count = counter
        }
    }

    Loader {
        id: loader
    }

    function show() {
        loader.sourceComponent = fileBrowserComponent
        loader.item.parent = fileBrowser
        loader.item.anchors.fill = fileBrowser
        loader.item.folder = fileBrowser.folder
        loader.item.count = fileBrowser.count
        loader.item.file = fileBrowser.file
    }

    function previous() {
        count--
        if (count < 0) count = 0
        var imageSource = loader.item.folders.get(count, "fileName")
        var s = extension(imageSource)
        if (s === ".png" || s === ".jpg" || s === ".txt") {
            var path = loader.item.folders.folder + "/" + imageSource
            fileSelected(path)
        } else {
            count++
        }
    }

    function next() {
        count++
        if (count === loader.item.folders.count) count = 0
        var imageSource = loader.item.folders.get(count, "fileName")
        var s = extension(imageSource)
        if (s === ".png" || s === ".jpg" || s === ".txt") {
            var path = loader.item.folders.folder + "/" + imageSource
            fileSelected(path)
        } else {
            count--
        }
    }

    function extension(str)
    {
        var s = (str.slice(str.lastIndexOf("/")+1))
        var f = s.indexOf(".")
        return s.slice(f)
    }

    Component {
        id: fileBrowserComponent

        Rectangle {
            id: root
            color: "black"
            property bool showFocusHighlight: false
            property variant folders: folders1
            property variant view: view1
            property alias folder: folders1.folder
            property color textColor: "white"
            property variant count: folders.count
            property string file

            FolderListModel {
                id: folders1
                folder: folder
                showDirsFirst: true
                //showDotAndDotDot: true
            }

            FolderListModel {
                id: folders2
                folder: folder
                showDirsFirst: true
                //showDotAndDotDot: true
            }

            SystemPalette {
                id: palette
            }

            Component {
                id: folderDelegate

                Rectangle {
                    id: wrapper
                    function launch() {
                        var path = "file://";
                        if (filePath.length > 2 && filePath[1] === ':') // Windows drive logic, see QUrl::fromLocalFile()
                            path += '/';
                        path += filePath;
                        if (folders.isFolder(index))
                            down(path);
                        else {
                            file = path
                            fileBrowser.selectFile(path, folders.indexOf(path))
                        }
                    }
                    width: root.width
                    height: itemHeight
                    color: "transparent"

                    Rectangle {
                        id: highlight; visible: false
                        anchors.fill: parent
                        color: palette.highlight
                        gradient: Gradient {
                            GradientStop { id: t1; position: 0.0; color: palette.highlight }
                            GradientStop { id: t2; position: 1.0; color: Qt.lighter(palette.highlight) }
                        }
                    }

                    Item {
                        width: itemHeight; height: itemHeight
                        Image {
                            source: "qrc:/images/icon_Folder.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.fill: parent
                            anchors.margins: scaledMargin
                            visible: folders.isFolder(index)
                        }
                    }

                    Text {
                        id: nameText
                        anchors.fill: parent; verticalAlignment: Text.AlignVCenter
                        text: fileName
                        anchors.leftMargin: itemHeight + scaledMargin
                        font.pixelSize: fontSize
                        color: (wrapper.ListView.isCurrentItem && root.showFocusHighlight) ? palette.highlightedText : textColor
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        id: mouseRegion
                        anchors.fill: parent
                        onPressed: {
                            root.showFocusHighlight = false;
                            wrapper.ListView.view.currentIndex = index;
                        }
                        onClicked: { if (folders === wrapper.ListView.view.model) launch() }
                    }

                    states: [
                        State {
                            name: "pressed"
                            when: mouseRegion.pressed
                            PropertyChanges { target: highlight; visible: true }
                            PropertyChanges { target: nameText; color: palette.highlightedText }
                        }
                    ]
                }
            }

            ListView {
                id: view1
                anchors.top: titleBar.bottom
                anchors.bottom: parent.bottom//cancelButton.top
                x: 0
                width: parent.width
                model: folders1
                delegate: folderDelegate
                highlight: Rectangle {
                    color: palette.highlight
                    visible: root.showFocusHighlight && view1.count != 0
                    gradient: Gradient {
                        GradientStop { id: t1; position: 0.0; color: palette.highlight }
                        GradientStop { id: t2; position: 1.0; color: Qt.lighter(palette.highlight) }
                    }
                    width: view1.currentItem == null ? 0 : view1.currentItem.width
                }
                highlightMoveVelocity: 1000
                pressDelay: 100
                focus: true
                state: "current"
                states: [
                    State {
                        name: "current"
                        PropertyChanges { target: view1; x: 0 }
                        PropertyChanges { target: view1; visible: true }
                    },
                    State {
                        name: "exitLeft"
                        PropertyChanges { target: view1; x: -root.width }
                        PropertyChanges { target: view1; visible: false }
                    },
                    State {
                        name: "exitRight"
                        PropertyChanges { target: view1; x: 2000 }//root.width }
                        PropertyChanges { target: view1; visible: false }
                    }
                ]
                //                transitions: [
                //                    Transition {
                //                        to: "current"
                //                        SequentialAnimation {
                //                            NumberAnimation { properties: "x"; duration: 250 }
                //                        }
                //                    },
                //                    Transition {
                //                        NumberAnimation { properties: "x"; duration: 250 }
                //                        NumberAnimation { properties: "x"; duration: 250 }
                //                    }
                //                ]
                Keys.onPressed: root.keyPressed(event.key)
            }

            ListView {
                id: view2
                anchors.top: titleBar.bottom
                anchors.bottom: parent.bottom
                x: 2000//parent.width
                width: parent.width
                model: folders2
                delegate: folderDelegate
                highlight: Rectangle {
                    color: palette.highlight
                    visible: root.showFocusHighlight && view2.count != 0
                    gradient: Gradient {
                        GradientStop { id: view2t1; position: 0.0; color: palette.highlight }
                        GradientStop { id: view2t2; position: 1.0; color: Qt.lighter(palette.highlight) }
                    }
                    width: view1.currentItem == null ? 0 : view1.currentItem.width
                }
                highlightMoveVelocity: 1000
                pressDelay: 100
                states: [
                    State {
                        name: "current"
                        PropertyChanges { target: view2; x: 0 }
                        PropertyChanges { target: view2; visible: true }
                    },
                    State {
                        name: "exitLeft"
                        PropertyChanges { target: view2; x: -root.width }
                        PropertyChanges { target: view2; visible: false }
                    },
                    State {
                        name: "exitRight"
                        PropertyChanges { target: view2; x: 2000 }//root.width }
                        PropertyChanges { target: view2; visible: false }
                    }
                ]
                //                transitions: [
                //                    Transition {
                //                        to: "current"
                //                        SequentialAnimation {
                //                            NumberAnimation { properties: "x"; duration: 250 }
                //                        }
                //                    },
                //                    Transition {
                //                        NumberAnimation { properties: "x"; duration: 250 }
                //                    }
                //                ]
                Keys.onPressed: root.keyPressed(event.key)
            }

            //            Button {
            //                id: cancelButton
            //                width: itemWidth
            //                height: itemHeight
            //                color: "#353535"
            //                anchors { bottom: parent.bottom; right: parent.right; margins: 5 * scaledMargin }
            //                text: "Cancel"
            //                horizontalAlign: Text.AlignHCenter
            //                onClicked: fileBrowser.selectFile("")
            //            }

            Keys.onPressed: {
                root.keyPressed(event.key);
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Select || event.key === Qt.Key_Right) {
                    view.currentItem.launch();
                    event.accepted = true;
                } else if (event.key === Qt.Key_Left) {
                    up();
                }
            }

            // titlebar
            Rectangle {
                color: "black"
                width: parent.width;
                height: itemHeight
                id: titleBar

                Rectangle {
                    id: upButton
                    width: titleBar.height
                    height: titleBar.height
                    color: "transparent"
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: scaledMargin

                    Image { anchors.fill: parent; anchors.margins: scaledMargin; source: "qrc:/images/icon_BackArrow.png" }
                    MouseArea { id: upRegion; anchors.fill: parent; onClicked: up() }
                    states: [
                        State {
                            name: "pressed"
                            when: upRegion.pressed
                            PropertyChanges { target: upButton; color: palette.highlight }
                        }
                    ]
                }

                Text {
                    anchors.left: upButton.right; anchors.right: parent.right; height: parent.height
                    anchors.leftMargin: 10; anchors.rightMargin: 4
                    text: folders.folder
                    color: "white"
                    elide: Text.ElideLeft; horizontalAlignment: Text.AlignLeft; verticalAlignment: Text.AlignVCenter
                    font.pixelSize: fontSize
                }
            }

            Rectangle {
                color: "#353535"
                width: parent.width
                height: 1
                anchors.top: titleBar.bottom
            }

            function down(path) {
                if (folders == folders1) {
                    view = view2
                    folders = folders2;
                    view1.state = "exitLeft";
                } else {
                    view = view1
                    folders = folders1;
                    view2.state = "exitLeft";
                }
                view.x = root.width;
                view.state = "current";
                view.focus = true;
                folders.folder = path;
            }

            function up() {
                var path = folders.parentFolder;
                if (path.toString().length === 0 || path.toString() === 'file:')
                    return;
                if (folders == folders1) {
                    view = view2
                    folders = folders2;
                    view1.state = "exitRight";
                } else {
                    view = view1
                    folders = folders1;
                    view2.state = "exitRight";
                }
                view.x = -root.width;
                view.state = "current";
                view.focus = true;
                folders.folder = path;
            }

            function keyPressed(key) {
                switch (key) {
                case Qt.Key_Up:
                case Qt.Key_Down:
                case Qt.Key_Left:
                case Qt.Key_Right: {
                    root.showFocusHighlight = true;
                }
                break;
                default:
                    // do nothing
                    break;
                }
            }
        }
    }
}
