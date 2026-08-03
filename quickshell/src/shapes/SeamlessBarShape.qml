import QtQuick
import "../../"

Canvas {
    id: root
    anchors.fill: parent

    property int leftWidth: 0
    property int centerWidth: 0
    property int rightWidth: 0

    property int notchHeight: 34   // Depth of the drop-down
    property int chamfer: 6        // Size of the 45-degree bottom corner cut
    
    property color color: Theme.bgPanel 

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onLeftWidthChanged: requestPaint()
    onCenterWidthChanged: requestPaint()
    onRightWidthChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d");
        ctx.reset();

        var leftW   = root.leftWidth
        var centerW = root.centerWidth
        var rightW  = root.rightWidth

        var c = root.chamfer
        var h = root.notchHeight
        var w = width

        var centerStart = (w / 2) - (centerW / 2)
        var centerEnd   = (w / 2) + (centerW / 2)
        var rightStart  = w - rightW

        // --- 1. DRAW BASE ISLAND PANELS ---
        ctx.beginPath();
        ctx.fillStyle = root.color;
        ctx.strokeStyle = Theme.borderIdle;
        ctx.lineWidth = 1;

        // LEFT ISLAND
        ctx.moveTo(0, 0);
        ctx.lineTo(0, h);
        ctx.lineTo(leftW - c, h);
        ctx.lineTo(leftW, h - c);
        ctx.lineTo(leftW, 0);

        // GAP 1
        ctx.lineTo(centerStart, 0);

        // CENTER ISLAND
        ctx.lineTo(centerStart, h - c);
        ctx.lineTo(centerStart + c, h);
        ctx.lineTo(centerEnd - c, h);
        ctx.lineTo(centerEnd, h - c);
        ctx.lineTo(centerEnd, 0);

        // GAP 2
        ctx.lineTo(rightStart, 0);

        // RIGHT ISLAND
        ctx.lineTo(rightStart, h - c);
        ctx.lineTo(rightStart + c, h);
        ctx.lineTo(w, h);
        ctx.lineTo(w, 0);

        ctx.closePath();
        ctx.fill();
        ctx.stroke();

        // --- 2. DRAW MONOWIRE FILAMENT LINE ALONG GAP TOP BEZEL ---
        ctx.beginPath();
        ctx.strokeStyle = Theme.monowireGlow;
        ctx.lineWidth = 1;

        // Gap 1 Line
        ctx.moveTo(leftW, 0);
        ctx.lineTo(centerStart, 0);

        // Gap 2 Line
        ctx.moveTo(centerEnd, 0);
        ctx.lineTo(rightStart, 0);

        ctx.stroke();
    }
}