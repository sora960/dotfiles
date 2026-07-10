# 🌐 EDGERUNNER HUD // SDDM LUCY THEME

An unrounded, high-contrast tactical login interface designed for daily-driver Linux environments, themed around the cybernetic design language of *Cyberpunk: Edgerunners*. Built as a standalone, streamlined modular codebase.

---

## 🎯 Project Goals
* **Fast Boot-Time Rendering:** Keep the login screen lightweight to minimize initialization time when SDDM loads the theme.
* **Reliable Mouse and Keyboard Usability:** Predictable focus navigation for both mouse-driven and keyboard-only operation.
* **Daily-Driver Friendly Visuals:** High-contrast tactical aesthetic that avoids eye-strain, flickering, or jarring graphical distortions.
* **Minimal Runtime Overhead:** Avoid unnecessary animations, canvas rendering, and continuous processing to keep resource usage low.
* **Easy Maintenance & Customization:** Cleanly separated code blocks allowing rapid adjustments to configurations or assets.

## 🎯 Code Quality
* **Modular Components:** Keep reusable widgets (such as `SessionButton.qml`) isolated while avoiding unnecessary abstraction for one-off elements to balance maintainability and structural clarity.

## 🎨 Design Philosophy & Aesthetic Manifesto
* **Calm While Idle:** Restrained, high-contrast cybernetic HUD panel. Clean, stable, and unobtrusive during standard user interaction.
* **Clear, Deliberate Error Feedback:** Failed operations should provide immediate, subtle visual confirmation without distracting from the core login experience.
* **No Gratuitous Visual Noise:** Zero persistent visual flickering, zero ambient screen-tearing shaders, and zero heavy RGB channel splitting.
* **Animations Under 250ms:** Every interface shift or recovery transition must execute and settle completely under this hard constraint to preserve interface responsiveness.

---

## 🗂️ Theme Implementation Matrix

### 🟩 PHASE 1: CORE HUD ARCHITECTURE (100% Complete)
* [x] **Standalone Primary Layout:** Core layout, timing loops, and style systems securely self-contained inside `Main.qml`.
* [x] **Hardware-Accelerated Video Background:** Background loop rendering (`lucy-live.mp4`) masked cleanly by a translucent `.05070c` dimming rectangle.
* [x] **Stark Contrast Palette Calibration:** Primary interface lines directly bound to defined configuration hexadecimal tokens (`#FCEE09` Yellow, `#94a3b8` Slate, `#111622` Dark-Box).
* [x] **Anti-Aliased Square Posture:** Enforced sharp, completely non-rounded visual boundaries across all panel assets (`radius: 0`).

### 🟩 PHASE 2: TACTICAL INTERACTION INTERFACE (100% Complete)
* [x] **Desktop Session Selector:** Fully customized, unrounded dropdown container querying the native `sessionModel` dynamically.
* [x] **Root Hardware Controls:** Symmetrically placed REBOOT and SHUTDOWN buttons wired directly to the native SDDM power management interface.
* [x] **Authentication Failure Feedback:** The `onLoginFailed` handler updates the HUD state, triggers visual error feedback, and automatically restores the idle appearance after a short timeout.
* [x] **Version Control:** Source code maintained in Git, synchronized with the local dotfiles repository, and backed up to GitHub.

### 🔲 PHASE 3: PRODUCTION POLISH & ACCESSIBILITY (Planned)
* [ ] **Password Field Cache-Clear:** Clear the password field immediately after authentication failure to avoid stale input and streamline retry attempts.
* [ ] **Symmetric Quad-Corner Framing:** Decorative indicator corner marks deployed symmetrically to frame all four visual corners of the outer container box.
* [ ] **Caps Lock Indicator:** Display a warning whenever Caps Lock is active during password entry.
* [ ] **Accessibility & Keyboard Focus Audit:** Verify absolute predictability of standard focus looping (`Tab`, `Shift+Tab`, `Enter`) jumping between the username field, password line, visibility checkbox, custom session picker, and power controls cleanly.
* [ ] **Remove Unused Legacy Theme Files:** Remove unused default template fragments (`LoginForm.qml`, `Clock.qml`, `UserList.qml`, etc.) from the active theme folder to reduce maintenance overhead.

### 🟦 PHASE 4: OPTIONAL VISUAL & AUDIO ENHANCEMENTS (Low Priority)
* [ ] **Optional UI Sound Effects:** Low-latency uncompressed `.wav` sound objects (`SoundEffect`) that play tactical cyber clicks on element hovers or form submission errors.
* [ ] **High-Frequency Visual Glitch:** Short-duration opacity flickering (~150ms total loop) bound strictly to the container box *only* during an active access denial event.
* [ ] **Optional Shader-Based Visual Effects:** Implement hardware-rendered visual overlay filters or scanline distortions *if* fully supported by the target environment's Qt framework version and graphics stack.

### 🟪 PHASE 5: COMPATIBILITY & MAINTENANCE (Not Started)
* [ ] **Test Multiple Aspect Ratios:** Verify consistent layout placement on 16:9, 16:10, and ultrawide displays if applicable.
* [ ] **Display Scaling Verification:** Validate structural alignment variables under alternative desktop scaling factors (100%, 125%, 150%).
* [ ] **Resolution Verification:** Confirm container placement properties translate cleanly between standard 1080p, 1440p, and 4K monitor resolutions.
* [ ] **Cross-Compositor Testing:** Cross-audit layout rendering parameters under both Wayland and X11 display protocols.
* [ ] **Installation & Customization Documentation:** Draft a clean, step-by-step setup script guide inside your dotfiles repository documenting installation, theme selection, and update procedures.
