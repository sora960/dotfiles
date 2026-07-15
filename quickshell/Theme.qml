pragma Singleton
import Quickshell
import QtQuick

// Single source of truth for the bar's palette/font.
// Hand-tweaked to transition away from aggressive game overlays
// into a lonely, grounded netrunner terminal atmosphere.
Singleton {
    // Deepest obsidian space gray — empty, vast backdrop
    readonly property color bgMain: "#0A0D14" 
    
    // Cold nocturnal glass panel base — matches the night-sky haze
    readonly property color bgPanel: "#141824" 
    
    // Dim, quiet slate-blue borders to keep application boundaries ghost-like
    readonly property color borderIdle: "#252E3F" 
    
    // Muted, distant terminal grey for secondary texts or inactive modules
    readonly property color textMuted: "#52637A" 
    
    // Pristine, light moon-grey for primary readouts and text focus
    readonly property color textMain: "#E2E8F0" 
    
    // Soft, moonlit cyan — your primary focus tint (replaces loud yellow)
    readonly property color accent: "#8ECAE6" 
    
    // Muted desaturated lavender — Lucy's true character tint, used sparingly
    readonly property color characterAccent: "#B19FFB" 
    
    // Warning state — a highly desaturated copper rather than sharp red
    readonly property color error: "#E05A65" 
    
    // Clean, technical typography tracking
    readonly property string fontFamily: "JetBrains Mono"
}