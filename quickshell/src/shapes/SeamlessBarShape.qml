import QtQuick

// --- ADD THIS LINE TO FIND Theme.qml ---
import "../../"

Canvas {
    id: root
    anchors.fill: parent

    // Dynamic widths bound from Bar.qml
    property int leftWidth: 0
    property int centerWidth: 0
    property int rightWidth: 0

    property int notchHeight: 34   // Depth of the drop-down
    property int radius: 8         // Smoothness of the concave/convex curves
    
    // SECRET 2: Force the bridge thickness to 0 so the gaps are completely empty!
    property int topBorderWidth: 0 
    
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

        var r = root.radius
        var h = root.notchHeight
        var b = root.topBorderWidth
        var w = width

        var centerStart = (w / 2) - (centerW / 2)
        var centerEnd   = (w / 2) + (centerW / 2)
        var rightStart  = w - rightW

        ctx.beginPath();
        ctx.fillStyle = root.color;
        
        // Optional: add a thin border around the whole shape
        ctx.strokeStyle = Theme.borderIdle;
        ctx.lineWidth = 1;

        // 1. LEFT NOTCH (Convex bottom, Concave top right)
        ctx.moveTo(0, h);
        ctx.lineTo(leftW - r, h);
        ctx.arcTo(leftW, h, leftW, h - r, r);
        ctx.lineTo(leftW, b + r);
        ctx.arcTo(leftW, b, leftW + r, b, r);

        // GAP 1
        ctx.lineTo(centerStart - r, b);

        // 3. CENTER NOTCH (Concave top left, Convex bottom, Concave top right)
        ctx.arcTo(centerStart, b, centerStart, b + r, r);
        ctx.lineTo(centerStart, h - r);
        ctx.arcTo(centerStart, h, centerStart + r, h, r);
        ctx.lineTo(centerEnd - r, h);
        ctx.arcTo(centerEnd, h, centerEnd, h - r, r);
        ctx.lineTo(centerEnd, b + r);
        ctx.arcTo(centerEnd, b, centerEnd + r, b, r);

        // GAP 2
        ctx.lineTo(rightStart - r, b);

        // 5. RIGHT NOTCH (Concave top left, Convex bottom)
        ctx.arcTo(rightStart, b, rightStart, b + r, r);
        ctx.lineTo(rightStart, h - r);
        ctx.arcTo(rightStart, h, rightStart + r, h, r);
        ctx.lineTo(w, h);

        // 6. CLOSE LOOP (Draws back across the absolute top edge)
        ctx.lineTo(w, 0);
        ctx.lineTo(0, 0);
        ctx.lineTo(0, h);

        ctx.fill();
        ctx.stroke(); // Draw the subtle outline
    }
}