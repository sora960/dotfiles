# Font Configuration

## Purpose

This system uses a **Noto-first font ecosystem** designed to provide broad Unicode coverage, dedicated CJK support, emoji support, and predictable font fallback without unnecessary font-package fragmentation.

The goal is to install the required coverage once and avoid ongoing manual font management.

---

## Font Packages

### Primary Unicode Coverage

| Package            | Purpose                                | Status    |
| ------------------ | -------------------------------------- | --------- |
| `noto-fonts`       | General Noto Unicode font collection   | Installed |
| `noto-fonts-cjk`   | Japanese, Chinese, and Korean coverage | Installed |
| `noto-fonts-emoji` | Color emoji                            | Installed |

### Supporting Fonts

| Package          | Reason                                                                           |
| ---------------- | -------------------------------------------------------------------------------- |
| `adwaita-fonts`  | Required by the GTK/GNOME stack and used by the current GNOME interface settings |
| `ttf-dejavu`     | Required by Firefox                                                              |
| `ttf-liberation` | Required by Firefox                                                              |

These supporting packages are **not considered redundant font bloat**. They remain installed because they have legitimate package-level consumers.

---

## Generic Font Defaults

Fontconfig currently resolves the generic font families as:

```text
sans       → Noto Sans
serif      → Noto Serif
monospace  → Noto Sans Mono
```

Verification:

```bash
fc-match sans
fc-match serif
fc-match monospace
```

Result:

```text
NotoSans-Regular.ttf: "Noto Sans" "Regular"
NotoSerif-Regular.ttf: "Noto Serif" "Regular"
NotoSansMono-Regular.ttf: "Noto Sans Mono" "Regular"
```

Therefore, Noto is already the system's generic fontconfig baseline.

---

## CJK Coverage

Dedicated CJK fonts are installed through:

```bash
sudo pacman -S noto-fonts-cjk
```

The package provides dedicated Noto coverage for:

* Japanese
* Simplified Chinese
* Traditional Chinese
* Korean

Verification:

```bash
fc-match 'Noto Sans CJK JP'
fc-match 'Noto Sans CJK SC'
fc-match 'Noto Sans CJK KR'
```

Result:

```text
NotoSansCJK-Regular.ttc: "Noto Sans CJK JP" "Regular"
NotoSansCJK-Regular.ttc: "Noto Sans CJK SC" "Regular"
NotoSansCJK-Regular.ttc: "Noto Sans CJK KR" "Regular"
```

---

## Emoji Coverage

Color emoji support is provided by:

```bash
sudo pacman -S --needed noto-fonts-emoji
```

Verification:

```bash
fc-match 'Noto Color Emoji'
```

Result:

```text
NotoColorEmoji.ttf: "Noto Color Emoji" "Regular"
```

---

## Unicode Fallback

The installed Noto collection contains specialized fonts for scripts that are not completely represented by the generic `Noto Sans` face.

Examples verified on this system include:

```text
Devanagari       → Noto Sans Devanagari
Thai             → Noto Sans Thai
Musical symbols  → Noto Music
Egyptian         → Noto Sans Egyptian Hieroglyphs
```

Fontconfig therefore uses the Noto family as a broad fallback ecosystem rather than requiring one physical font file to contain every Unicode character.

---

## Existing Application Dependencies

Some fonts outside the Noto family remain installed because applications require them.

Current package inspection established:

```text
noto-fonts
    Required By: firefox

ttf-dejavu
    Required By: firefox

ttf-liberation
    Required By: firefox

adwaita-fonts
    Required By: gsettings-desktop-schemas, gtk3
```

These dependencies are the reason these packages should **not** be removed simply to reduce the number of visible font families.

---

## GNOME / GTK Font Settings

The current GNOME interface settings are:

```text
UI font       → Adwaita Sans 11
Document font → Adwaita Sans 12
```

Retrieved with:

```bash
gsettings get org.gnome.desktop.interface font-name
gsettings get org.gnome.desktop.interface document-font-name
```

Output:

```text
'Adwaita Sans 11'
'Adwaita Sans 12'
```

These settings apply to applications that honor the corresponding GNOME/GTK settings. Applications such as terminals, Hyprland components, Waybar, and Qt applications may define their own fonts independently.

---

## Design Decision

The system intentionally follows this policy:

> **Noto is the primary Unicode font ecosystem; specialized Noto faces provide script-specific coverage; package-required fonts remain installed when applications depend on them.**

This avoids two undesirable extremes:

1. Installing a large collection of unrelated font families.
2. Removing legitimate dependencies in pursuit of an artificially small font list.

A single physical font file cannot provide complete coverage for all Unicode scripts. Fontconfig's fallback mechanism is therefore used as intended.

---

## Final State

The font configuration is considered **complete for normal desktop use**.

Installed coverage includes:

```text
General Unicode      → Noto
CJK                  → Noto CJK
Emoji                → Noto Color Emoji
Specialized scripts  → Noto specialized families
GTK/GNOME             → Adwaita
Firefox dependencies → DejaVu / Liberation
```

No further font installation or removal is required unless a future application or language requirement demonstrates an actual coverage gap.

**Font configuration is considered closed.**

