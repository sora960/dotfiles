# Arch/CachyOS System Audit & Baseline

**System:** Arch Linux / CachyOS
**Desktop:** Hyprland / Wayland
**Audit date:** September 5, 2026
**Authoritative package snapshot:** `sudo pacman -Q` output captured on September 5, 2026

---

## 1. Audit Result

The system is accepted as a **legitimate, coherent and functional Arch/CachyOS workstation baseline**.

The installed package count is approximately **510 packages**.

The package count itself is **not a problem and is not a target for reduction**.

The important audit findings were:

```text
pacman -Qdt    → no output
pacman -Qm     → no output
pacman -Qe     → explicit package roots
pacman -Q      → complete installed-package snapshot
```

### Conclusions

* **No dependency orphans were reported.**
* **No foreign packages were reported by pacman.**
* Explicitly installed packages represent intentional system and software roots.
* The remaining packages form the dependency closure required by those roots and their functionality.
* The system contains the expected operating-system, hardware, networking, graphics, audio, desktop, development and application dependencies.
* Packages should not be removed merely because they are libraries, have no reverse dependency, are unfamiliar, or are not part of the minimal `base` installation.

### Final Decision

> **KEEP THE CURRENT PACKAGE SET AS THE BASELINE.**

---

# 2. What the Pacman Audit Establishes

## `pacman -Q`

Lists all installed packages.

This is the authoritative inventory of what is currently installed.

It does not determine whether every package is individually necessary.

---

## `pacman -Qe`

Lists packages explicitly installed by the user or marked explicit.

These represent the system's **intentional package roots**.

An explicit package can legitimately show:

```text
Required By: None
```

For example, an application does not need another installed package to depend on it in order to be intentional.

Therefore:

> `Required By: None` is not a removal criterion.

---

## `pacman -Qdt`

Lists dependency-installed packages that are no longer required by any installed package.

Current result:

```text
NO OUTPUT
```

Therefore:

> **No dependency orphans were identified during the audit.**

---

## `pacman -Qm`

Lists packages considered foreign to the configured repositories.

Current result:

```text
NO OUTPUT
```

Therefore:

> **No foreign packages were identified by pacman during the audit.**

---

# 3. System Functional Baseline

The workstation is intentionally a complete graphical development system rather than a minimal command-line installation.

## Core Operating System

The system contains the normal Arch foundation, including:

* `base`
* `glibc`
* `bash`
* `coreutils`
* `filesystem`
* `systemd`
* `systemd-libs`
* `util-linux`
* `kmod`
* `shadow`
* `pam`
* `sudo`
* `mkinitcpio`
* `linux-api-headers`
* `tzdata`
* filesystem, process, compression, terminal and system utilities

These provide the operating-system foundation.

---

## Kernel and Hardware

Installed hardware-support components include:

* `linux-cachyos`
* `linux-firmware-amdgpu`
* `linux-firmware-realtek`
* `linux-firmware-whence`
* `amd-ucode`
* `hwdata`
* `pciutils`
* USB libraries
* `libinput`
* `libevdev`
* `libwacom`
* `upower`
* `lm_sensors`
* `v4l-utils`

These provide kernel, firmware, device, input, power and hardware support.

---

# 4. CachyOS Integration

The system uses the CachyOS environment and repositories.

Installed components include:

* `cachyos-keyring`
* `cachyos-mirrorlist`
* `cachyos-v3-mirrorlist`
* `cachyos-settings`
* `cachyos-ananicy-rules`
* `ananicy-cpp`

These are intentional parts of the CachyOS environment and should not be treated as unnecessary simply because they are absent from a minimal upstream Arch installation.

---

# 5. Package Management and Build Environment

The package-management and build environment includes:

* `pacman`
* `pacman-contrib`
* `pacman-mirrorlist`
* `archlinux-keyring`
* `paru`
* `base-devel`
* `git`
* `curl`
* `gcc`
* `binutils`
* `make`
* `autoconf`
* `automake`
* `m4`
* `bison`
* `flex`
* `fakeroot`
* `debugedit`
* `gdb`
* `pkgconf`
* `gettext`
* `groff`
* `texinfo`
* `patch`
* Perl development/runtime components

`base-devel` is intentionally retained as the build environment.

`paru` is retained as the AUR helper.

`pacman-contrib` provides administrative utilities including:

* `pactree`
* `checkupdates`
* `paccache`
* `pacdiff`
* `pacsearch`
* `paclist`
* `pacscripts`
* `pacsort`

These are legitimate package-management tools.

---

# 6. Graphical Desktop Baseline

The desktop environment is:

* Hyprland
* UWSM
* Wayland
* Wayland protocols
* XWayland
* Waybar
* Mako
* Rofi
* Kitty
* XDG Desktop Portal
* GTK/GLib/Pango/Cairo components
* fonts and icon themes
* input and keyboard components

The associated GTK, Wayland, X11, font, rendering and desktop-integration libraries are expected dependencies of the graphical environment.

Their presence does not indicate system bloat.

---

# 7. Graphics Baseline

The graphics stack includes:

* `mesa`
* `vulkan-radeon`
* `vulkan-icd-loader`
* `vulkan-mesa-implicit-layers`
* `libdrm`
* `libglvnd`
* `libdisplay-info`
* `glslang`
* `shaderc`
* `spirv-tools`
* `llvm-libs`
* XWayland and associated graphics libraries

This provides the AMD GPU graphics stack required by the current Wayland/Hyprland environment.

---

# 8. Networking Baseline

The system uses NetworkManager to manage both wired and wireless networking.

Components include:

* `networkmanager`
* `wpa_supplicant`
* `iproute2`
* `iputils`
* `iw`
* `nftables`
* `iptables`
* `wireless-regdb`
* `libnm`
* `libnl`
* `libndp`
* TLS/cryptographic libraries
* `ca-certificates`
* `ca-certificates-mozilla`

These provide network management, wireless authentication, routing, firewall functionality, certificates and network protocol support.

## Interface Priority

Two network interfaces are configured:

| Interface    | Connection           | Route Metric | Role     |
| ------------ | -------------------- | -----------: | -------- |
| `enp5s0`     | `Wired connection 1` |        `100` | Primary  |
| `wlp9s0f3u1` | `PLDTHOMEFIBR45010`  |        `600` | Fallback |

The lower metric gives Ethernet routing priority while Wi-Fi remains available as a fallback when its connection is active.

Configuration:

```bash
nmcli connection modify "Wired connection 1" ipv4.route-metric 100
nmcli connection modify "PLDTHOMEFIBR45010" ipv4.route-metric 600
```

Verify routing with:

```bash
ip route
ip route get 1.1.1.1
```

The expected result when Ethernet is active is that traffic to `1.1.1.1` selects `enp5s0`.

---

# 9. Audio Baseline

The audio stack consists of:

* `pipewire`
* `pipewire-audio`
* `pipewire-pulse`
* `pipewire-jack`
* `pipewire-session-manager`
* `wireplumber`
* `alsa-lib`
* `alsa-ucm-conf`
* `alsa-card-profiles`
* `rtkit`
* audio codecs and processing libraries

PipeWire was previously tested while an existing PipeWire instance was already running. Attempting to start another instance produced a lock-file error.

This indicated an already-running PipeWire instance rather than a broken installation.

---

# 10. Memory and Swap

The system uses zram for compressed swap.

Installed:

```text
zram-generator
```

Verified runtime state:

```text
/dev/zram0
TYPE: partition
SIZE: 8G
PRIORITY: 100
```

The corresponding systemd unit:

```text
systemd-zram-setup@zram0.service
```

was active during the audit.

### Decision

```text
KEEP
```

`zram-generator` is an actively used part of the current system.

---

# 11. Core Systemd Service Baseline

The audited system had the following expected running system services:

| Service                    | Functional Role                    |
| -------------------------- | ---------------------------------- |
| `dbus-broker.service`      | System D-Bus message bus           |
| `getty@tty1.service`       | TTY1 login                         |
| `polkit.service`           | Privilege authorization            |
| `systemd-journald.service` | System logging                     |
| `systemd-logind.service`   | Session, seat and power management |
| `systemd-udevd.service`    | Hardware/device management         |
| `user@1000.service`        | User-level systemd instance        |
| `NetworkManager.service`   | Network management                 |
| `wpa_supplicant.service`   | Wireless authentication            |
| `systemd-resolved.service` | DNS resolution                     |
| `ananicy-cpp.service`      | Process priority management        |
| `rtkit-daemon.service`     | Realtime scheduling support        |

Verify the current state with:

```bash
systemctl list-units --type=service --state=running
```

This list represents the audited baseline, not a universal requirement that every future system state must contain exactly these services.

Additional services may legitimately appear after software or configuration changes.

---

# 12. Intentional System Configuration

## `systemd-userdbd`

The following units were intentionally masked:

```text
systemd-userdbd.service
systemd-userdbd.socket
```

They were masked to `/dev/null`.

The system does not currently require the functionality provided by these units.

Re-enable if future software or configuration requires them:

```bash
sudo systemctl unmask systemd-userdbd.service systemd-userdbd.socket
```

---

## Display Manager

No display manager is intentionally used.

SDDM, GDM and LightDM are absent from the current desktop login path.

The workstation instead uses direct TTY1 login followed by the user shell and UWSM.

---

# 13. TTY1 Login Configuration

The workstation uses a custom systemd getty drop-in:

```text
/etc/systemd/system/getty@tty1.service.d/autologin.conf
```

Configuration:

```ini
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty -o '-p -- lucy' --noclear %I $TERM
```

This configuration **prefills the username** while still requiring password authentication.

It is not `agetty --autologin`; the password prompt remains part of the authentication flow.

The custom configuration also uses:

```text
--noclear
```

so the TTY screen is not cleared when `agetty` starts.

Verify with:

```bash
systemctl cat getty@tty1.service
```

---

# 14. Boot-to-Desktop Flow

The intentional login/session path is:

```text
Firmware
   ↓
Kernel
   ↓
systemd
   ↓
getty@tty1.service
   ↓
agetty
   ↓
Password authentication
   ↓
/bin/bash
   ↓
~/.bash_profile
   ↓
UWSM
   ↓
Hyprland
   ↓
User session / autostart services
```

The relevant `.bash_profile` condition is:

```bash
if [[ -z "${WAYLAND_DISPLAY}" && "${XDG_VTNR}" == "1" ]]; then
    exec uwsm start -e -D Hyprland hyprland.desktop
fi
```

The condition ensures that UWSM launches Hyprland when the shell is running on TTY1 and a Wayland display has not already been established.

This provides a direct:

```text
TTY1 → Bash → UWSM → Hyprland
```

session path without a display manager.

---

# 15. Previously Investigated Components

The following components were specifically investigated during the audit.

## Mako

Verified as the active notification daemon.

```text
/usr/bin/mako
```

Decision:

```text
KEEP
```

---

## RTKit

Verified:

```text
rtkit-daemon.service
Active: active (running)
```

RTKit was observed providing realtime scheduling support.

Decision:

```text
KEEP
```

Its activation state should not be judged solely by whether a persistent process appears to be doing work at a particular moment.

---

## Rofi

`rofi` is explicitly installed.

Decision:

```text
KEEP IF USER WANTS ROFI
```

Its lack of reverse dependencies does not make it an orphan.

---

## pacman-contrib

Provides administrative package-management tools.

Decision:

```text
KEEP / ADMIN TOOLING
```

---

# 16. Why Approximately 510 Packages Is Normal

The installed package count does not represent the number of independent applications.

A modern graphical system contains a large dependency closure:

```text
Application
    ↓
Toolkit
    ↓
Graphics libraries
    ↓
Font libraries
    ↓
Image libraries
    ↓
Text/rendering libraries
    ↓
System libraries
```

The same principle applies to:

* Hyprland
* Firefox
* PipeWire
* Waybar
* Kitty
* Neovim
* Vulkan/Mesa
* NetworkManager
* development tools
* multimedia support
* desktop portals

Therefore:

> **Package count is not a reliable measure of system bloat.**

The meaningful maintenance question is whether installed packages are unexplained, unwanted, or genuinely orphaned.

The audit found no dependency orphans.

---

# 17. What This Audit Does Not Claim

This audit does **not** claim that every package in the approximately 510-package inventory has been individually proven indispensable.

That is neither necessary nor a useful maintenance standard.

The installed package set consists of several categories:

### Required dependencies

Packages required by other installed packages.

### Explicit package roots

Packages intentionally installed as user/software roots.

Examples include:

* Firefox
* Hyprland
* Kitty
* Neovim
* Waybar
* Mako
* Rofi
* Git
* Paru
* development tools

These can legitimately have no reverse dependencies.

### Dependency orphans

Packages that were installed as dependencies but are no longer required.

These are what:

```bash
pacman -Qdt
```

is intended to identify.

Current audit result:

```text
TRUE ORPHANS: NONE
```

---

# 18. Correct Future Maintenance Procedure

A complete package-by-package audit should not be repeated merely because the package count changes.

Use:

```bash
pacman -Qdt
```

to check for dependency orphans.

Use:

```bash
pacman -Qm
```

to check for foreign packages.

Use:

```bash
pacman -Qe
```

to review explicit package roots.

Use:

```bash
pactree -r PACKAGE
```

when investigating whether a package is required by another installed package.

Use:

```bash
pacman -Ql PACKAGE
```

when determining what files a package provides.

Before removing a package, inspect the transaction proposed by pacman.

---

# 19. Removal Decision Rule

A package should **not** be removed solely because:

* it is unfamiliar;
* it is a library;
* it has `Required By: None`;
* it is part of a large dependency chain;
* it belongs to a higher functional tier;
* it is not part of `base`;
* it is not visibly running as a process;
* it is small;
* another package could theoretically provide similar functionality.

A package becomes a reasonable removal candidate when there is evidence that:

1. it is no longer wanted functionality;
2. it is a genuine dependency orphan; or
3. it was explicitly installed accidentally and is confirmed to be unwanted.

---

# 20. Audit Limitations

This audit establishes the state of the package database and the major system components at the time of the audit.

It does not permanently guarantee that:

* future package updates will preserve the same versions;
* future configuration changes will preserve the same service state;
* applications will never introduce additional dependencies;
* every runtime state will remain identical;
* network failover will preserve every existing network connection.

Future system changes should be evaluated against the current functional baseline rather than against a fixed package count.

---

# 21. Authoritative Package Snapshot

The complete:

```bash
sudo pacman -Q
```

output captured on **September 5, 2026** is the authoritative package snapshot for this audit.

It records the installed package inventory at that point in time.

Future package changes should be compared against a new snapshot when necessary rather than attempting to preserve the original package count.

---

# 22. Final Audit Status

```text
╔════════════════════════════════════════════╗
║       ARCH/CACHYOS SYSTEM AUDIT            ║
╠════════════════════════════════════════════╣
║ Audit date:             2026-09-05          ║
║ Installed packages:    ~510                ║
║ True orphans (Qdt):     NONE               ║
║ Foreign packages (Qm):  NONE               ║
║ Explicit roots (Qe):    PRESENT            ║
║ Desktop:                Hyprland/Wayland   ║
║ Audio:                  PipeWire            ║
║ Network:                NetworkManager     ║
║ GPU:                    AMD/Vulkan/Mesa    ║
║ Swap:                   zram                ║
║ Notifications:          Mako                ║
║ RT scheduling:          RTKit               ║
║ Build environment:      base-devel         ║
║ Login:                  TTY1 + UWSM         ║
╠════════════════════════════════════════════╣
║ FINAL STATUS: ACCEPTED AS BASELINE         ║
╚════════════════════════════════════════════╝
```

---

# 23. Final Baseline Principle

> **The goal is not the smallest possible Arch installation.**
>
> **The goal is a known, functional, intentionally configured system with no unexplained dependency orphans.**

The September 5, 2026 audit established that baseline.

The documented TTY1 login path, UWSM/Hyprland session flow, networking priority, core service configuration, zram configuration and package state represent the known system configuration resulting from the audit.

Future changes should be made deliberately, verified afterward, and documented when they alter the system baseline.

