function enterInitialState() {
    transitionRect.visible = false
    previousRect.visible = false
    nextRect.visible = false
    fullScreenRect.visible = false
    fitZoomRect.visible = false
    fitScreenRect.visible = false
    zoomInRect.visible = false
    zoomOutRect.visible = false
    drawRect.visible = false
    toolRect.visible = false
    fileRect.visible = false
    fileLabel.visible = false
    fileToolRect.visible = false
    canvasMouseArea.preventStealing = false
    drawRect.border.color = "transparent"
    drawRect.border.width = 0
    fileRect.border.color = "transparent"
    fileRect.border.width = 0
    textRect.visible = false
    textRect.border.color = "transparent"
    textRect.border.width = 0
}

function enterShowToolState() {
    transitionRect.visible = true
    previousRect.visible = true
    nextRect.visible = true
    fullScreenRect.visible = true
    fitZoomRect.visible = true
    fitScreenRect.visible = true
    zoomInRect.visible = true
    zoomOutRect.visible = true
    drawRect.visible = true
    toolRect.visible = false
    fileRect.visible = true
    fileLabel.visible = true
    textRect.visible = true
    fileToolRect.visible = false
    canvasMouseArea.cursorShape = Qt.ArrowCursor
}

function enterDrawState() {
    transitionRect.visible = false
    previousRect.visible = false
    nextRect.visible = false
    fullScreenRect.visible = false
    fitZoomRect.visible = false
    fitScreenRect.visible = false
    zoomInRect.visible = false
    zoomOutRect.visible = false
    drawRect.visible = true
    toolRect.visible = true
    fileRect.visible = false
    fileLabel.visible = false
    canvasMouseArea.preventStealing = true
    canvasMouseArea.cursorShape = Qt.PointingHandCursor
    drawRect.border.color = window.color
    drawRect.border.width = 8
    textRect.visible = false
}

function enterFileState() {
    transitionRect.visible = false
    previousRect.visible = false
    nextRect.visible = false
    fullScreenRect.visible = false
    fitZoomRect.visible = false
    fitScreenRect.visible = false
    zoomInRect.visible = true
    zoomOutRect.visible = true
    drawRect.visible = false
    toolRect.visible = false
    fileRect.visible = true
    fileLabel.visible = true
    fileToolRect.visible = true
    fileRect.border.color = window.color
    fileRect.border.width = 8
}
