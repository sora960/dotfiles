# Lucy's Melancholy - SDDM Theme

A minimalist, atmospheric SDDM login theme inspired by the quiet longing of *Cyberpunk: Edgerunners*.

Moving away from loud, gamified hacker interfaces, this theme focuses on a grounded, **"mellow solitude"** aesthetic. It features a transparent floating-island panel, restrained visual feedback, and deep contrast.

---

## ✨ Design Philosophy

- **Mellow Solitude** — A quiet, unobstructed view of the background.
- **Floating Island Panel** — Interface elements are contained within a single, softly rounded, semi-transparent island.
- **Restrained Feedback** — No violent glitches or screen tearing. Authentication failures are handled with elegant, deliberate color shifts (Soft White → Alert Red).
- **Zero Bloat** — Stripped of unnecessary animations, legacy configurations, and heavy resource usage to ensure a blazing-fast boot time.

---

## 📂 File Architecture

The theme is intentionally modular to keep the root directory clean and maintainable.

```text
lucy/
├── Main.qml
├── theme.conf
├── Components/
│   ├── Clock.qml
│   ├── UserInputs.qml
│   ├── SessionButton.qml
│   ├── PowerButtons.qml
│   └── ...
└── Assets/
    ├── shutdown.svg
    ├── reboot.svg
    └── ...
```

### Structure

| File/Folder | Description |
|-------------|-------------|
| `Main.qml` | Core layout, animations, and background handler. |
| `theme.conf` | Easy customization for background, colors, fonts, and sizing. |
| `Components/` | Modular QML components for UI elements. |
| `Assets/` | Lightweight SVG icons used throughout the interface. |

---

## 🚀 Installation

1. Copy the theme into the SDDM themes directory.

```bash
sudo cp -r lucy /usr/share/sddm/themes/
```

2. Enable the theme by editing `/etc/sddm.conf` (or creating a file inside `/etc/sddm.conf.d/`).

```ini
[Theme]
Current=lucy
```

3. Test the theme without rebooting.

```bash
sddm-greeter --test-mode --theme /usr/share/sddm/themes/lucy
```

---

## 🎨 Features

- Transparent floating login panel
- Atmospheric minimalist design
- Lightweight and responsive
- Modular QML architecture
- Easy customization through `theme.conf`
- Soft authentication feedback
- Fast startup with minimal resource usage

---

## 📸 Inspiration

Inspired by the melancholic atmosphere and quiet emotional tone of **Cyberpunk: Edgerunners**, Lucy's Melancholy aims to create a login experience that feels calm, minimalist, and contemplative rather than flashy or overly animated.
