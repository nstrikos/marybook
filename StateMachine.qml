import QtQuick 2.15
import QtQuick.Window 2.15

import Qt.labs.platform 1.1

import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.3

import Qt.labs.settings 1.0

import QtQml.StateMachine 1.0 as DSM

DSM.StateMachine {
    id: stateMachine
    initialState: initialState
    running: true

    property bool drawStateActive: drawState.active

    DSM.State {
        id: initialState
        DSM.SignalTransition {
            targetState: showToolState
            signal: mouseAreaPressed
            guard: mySplitView.mousePressed === false
        }
        DSM.SignalTransition {
            targetState: showToolState
            signal: updatePage
        }
        onEntered: {
            console.log("initial state")
            mySplitView.enterInitialState()
        }
    }

    DSM.State {
        id: showToolState
        DSM.SignalTransition {
            targetState: initialState
            signal: mouseAreaPressed
            guard: mySplitView.mousePressed === false
        }
        DSM.SignalTransition {
            targetState: showToolState
            signal: updatePage
        }
        DSM.SignalTransition {
            targetState: drawState
            signal: drawButtonPressed
        }
        DSM.SignalTransition {
            targetState: fileState
            signal: fileButtonPressed
        }
        onEntered: {
            console.log("showTool state")
            mySplitView.enterShowToolState()
        }
    }

    DSM.State {
        id: drawState
        DSM.SignalTransition {
            targetState: initialState
            signal: drawButtonPressed
        }
        DSM.SignalTransition {
            targetState: showToolState
            signal: updatePage
        }
        onEntered: {
            console.log("draw state")
            mySplitView.enterDrawState()
        }
    }

    DSM.State {
        id: fileState
        DSM.SignalTransition {
            targetState: initialState
            signal: fileButtonPressed
        }
        DSM.SignalTransition {
            targetState: initialState
            signal: mouseAreaPressed
        }
        DSM.SignalTransition {
            targetState: showToolState
            signal: updatePage
        }
        onEntered: {
            console.log("file state")
            mySplitView.enterFileState()
        }
    }
}
