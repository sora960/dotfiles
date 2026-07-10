# 🌐 EDGERUNNER HUD // SDDM LUCY THEME

A lightweight SDDM theme inspired by the cybernetic interface design language of *Cyberpunk: Edgerunners*.

The theme prioritizes fast startup, keyboard accessibility, restrained visual feedback, and maintainable QML over excessive visual effects, making it suitable for everyday use.

---

## Preview

![Lucy Theme Preview](preview.png)

---

## Built With

- SDDM
- Qt Quick (QML)
- Qt Quick Controls 2
- Qt Multimedia

---

## 🎯 Project Goals

- **Fast Boot-Time Rendering:** Keep the login screen lightweight to minimize initialization time when SDDM loads the theme.
- **Reliable Mouse and Keyboard Usability:** Predictable focus navigation for both mouse-driven and keyboard-only operation.
- **Daily-Driver Friendly Visuals:** High-contrast tactical aesthetic that avoids eye strain, flickering, or distracting visual effects.
- **Minimal Runtime Overhead:** Avoid unnecessary animations, canvas rendering, and continuous processing to keep resource usage low.
- **Easy Maintenance & Customization:** Keep the code organized so assets and behavior are easy to modify.

## 🎯 Code Quality

- **Modular Components:** Keep reusable widgets (such as `SessionButton.qml`) isolated while avoiding unnecessary abstraction for one-off elements.

## 🎨 Design Philosophy

- **Calm While Idle:** Restrained, high-contrast cybernetic HUD panel.
- **Clear, Deliberate Error Feedback:** Failed operations should provide immediate, subtle visual confirmation without distracting from the login experience.
- **No Gratuitous Visual Noise:** No persistent flickering, screen tearing, or heavy RGB splitting.
- **Animations Under 250 ms:** Interaction animations should complete quickly and return to the idle state.

---

# Installation

## 1. Install the theme

Copy the theme into the SDDM themes directory:

    sudo cp -r lucy /usr/share/sddm/themes/

## 2. Configure SDDM

Set the active theme:

    [Theme]
    Current=lucy

This can be placed in `/etc/sddm.conf` or an appropriate file under `/etc/sddm.conf.d/`.

## 3. Test Before Rebooting

Always verify the theme before logging out:

    sddm-greeter --test-mode --theme /usr/share/sddm/themes/lucy

---

# Theme Roadmap

## 🟩 Phase 1 — Core HUD Architecture

- [x] Standalone Primary Layout
- [x] Hardware-Accelerated Video Background
- [x] High-Contrast Color Palette
- [x] Square Interface Geometry

## 🟩 Phase 2 — Tactical Interaction

- [x] Desktop Session Selector
- [x] Native REBOOT / SHUTDOWN controls
- [x] Authentication Failure Feedback
- [x] Git version control

## 🔲 Phase 3 — Production Polish

- [ ] Password Field Cache-Clear
- [ ] Symmetric Quad-Corner Framing
- [ ] Caps Lock Indicator
- [ ] Keyboard Focus Audit
- [ ] Remove Unused Legacy Theme Files

## 🟦 Phase 4 — Optional Enhancements

- [ ] Optional UI Sound Effects
- [ ] Subtle Access-Denied Glitch Animation
- [ ] Optional Shader-Based Effects

## 🟪 Phase 5 — Compatibility & Maintenance

- [ ] Test Multiple Aspect Ratios
- [ ] Display Scaling Verification
- [ ] Resolution Verification
- [ ] Wayland / X11 Testing
- [ ] Installation & Customization Documentation
