pragma Singleton
import Quickshell
import QtQuick

// Single source of truth for the bar's palette/font.
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
    
    // Soft, moonlit cyan — your primary focus tint
    readonly property color accent: "#8ECAE6" 
    
    // Muted desaturated lavender — Lucy's true character tint
    readonly property color characterAccent: "#B19FFB" 
    
    // Lucy Monowire Yellow/Orange Accents
    readonly property color monowireYellow: "#FEE75C" 
    readonly property color monowireGlow:   "#FFAA00" 
    readonly property color borderActive:   "#FFAA00" 
    
    // Warning state — a highly desaturated copper rather than sharp red
    readonly property color error: "#E05A65" 
    
    // Clean, technical typography tracking
    readonly property string fontFamily: "JetBrains Mono"
}