# Lean System Baseline & Boot Flow

This document outlines the audited systemd service baseline and the streamlined TTY1 boot flow for this workstation.

---

## 1. Minimal Active Services Baseline (12 Total)

The system runs with no display manager (pure TTY) and no redundant background daemons.

Run:

```bash
systemctl list-units --type=service --state=running
```

to verify the system against this expected baseline:

| Service                    | Functional Role                                                     |
| :------------------------- | :------------------------------------------------------------------ |
| `dbus-broker.service`      | High-performance D-Bus system message bus implementation.           |
| `getty@tty1.service`       | Virtual console manager on TTY1 with a custom prefilled login.      |
| `polkit.service`           | Privilege authorization manager for user session actions.           |
| `systemd-journald.service` | System event logging daemon.                                        |
| `systemd-logind.service`   | Seat management, session tracking, and power-state handling.        |
| `systemd-udevd.service`    | Hardware event and device-node manager.                             |
| `user@1000.service`        | Per-user systemd user instance running user-space units.            |
| `NetworkManager.service`   | Network connection management for Ethernet and Wi-Fi.               |
| `wpa_supplicant.service`   | WPA/WPA2/WPA3 wireless link authentication daemon.                  |
| `systemd-resolved.service` | Local caching DNS resolver backing the `/etc/resolv.conf` stub.     |
| `ananicy-cpp.service`      | C++ process auto-renicing daemon for active game/window priorities. |
| `rtkit-daemon.service`     | Realtime privilege provider for low-latency PipeWire audio.         |

---

## 2. Intentionally Masked / Disabled Units

### `systemd-userdbd.service` and `systemd-userdbd.socket`

* **Status:** Masked to `/dev/null`.
* **Reason:** Provides user-record lookup functionality used by components such as `systemd-homed` and portable services. It is unnecessary for this single-user bare-metal installation.
* **Re-enable:**

```bash
sudo systemctl unmask systemd-userdbd.service systemd-userdbd.socket
```

### Display Managers

* **Status:** Not installed.
* **Reason:** SDDM, GDM, and LightDM are intentionally absent. The system uses a lightweight TTY1 login instead.

---

## 3. TTY1 Prefilled Username Configuration

Rather than running a display manager or using `--autologin` (which eliminates password authentication), TTY1 is configured to prefill the username `lucy` while still requiring the user's password.

### Drop-in Location

```text
/etc/systemd/system/getty@tty1.service.d/autologin.conf
```

### Configuration

```ini
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty -o '-p -- lucy' --noclear %I $TERM
```

### Mechanism

* `ExecStart=` clears the upstream `ExecStart` definition inherited from `/usr/lib/systemd/system/getty@.service`.
* `-o '-p -- lucy'` passes options to `/bin/login`, preserving the environment and preselecting the username `lucy`.
* TTY1 displays the username automatically and proceeds to the password prompt.
* Password authentication remains enabled.
* Other virtual terminals (`tty2` through `tty6`) remain unmodified.

---

## 4. Boot-to-Desktop Execution Sequence

### 1. Firmware / Kernel Initialization

The firmware and kernel initialize the system and eventually present TTY1 without clearing the existing screen contents because `agetty` is configured with `--noclear`.

### 2. Authentication

`agetty` pre-fills the username `lucy`.

The user enters their password to authenticate.

### 3. Shell Initialization

After authentication, `/bin/bash` starts and reads:

```text
/home/lucy/.bash_profile
```

### 4. Session Handoff

The shell checks whether the current session is TTY1 and whether a Wayland session is not already active:

```bash
if [[ -z "${WAYLAND_DISPLAY}" && "${XDG_VTNR}" == "1" ]]; then
    exec uwsm start -e -D Hyprland hyprland.desktop
fi
```

If both conditions are satisfied, the shell hands control to `uwsm`, which starts the Hyprland session.

### 5. Environment & User Services

`uwsm` initializes the Wayland session environment and starts the associated user-session components and autostart units.

The resulting flow is:

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
uwsm
   ↓
Hyprland
   ↓
User session / autostart services
```

---

## 5. Verification

### Verify the Active Service Baseline

```bash
systemctl list-units --type=service --state=running
```

Compare the output against the expected baseline in Section 1.

### Verify TTY1 Configuration

```bash
systemctl cat getty@tty1.service
```

Confirm that the TTY1 drop-in contains the custom `agetty` command.

### Verify the Documentation File

From `~/dotfiles/docs`:

```bash
head -n 5 lean-system-baseline.md
```

The first line should be:

```text
# Lean System Baseline & Boot Flow
```

### Verify Git Tracking Status

```bash
git status -s lean-system-baseline.md
```

If the file has not yet been added to Git, the expected output is:

```text
?? lean-system-baseline.md
```

This indicates that the documentation file exists and is currently untracked.


---

## 5. Dual Interface Routing & Automatic Failover

The workstation operates with dual network adapters: onboard gigabit Ethernet (`enp5s0`) and a secondary Wi-Fi dongle (`wlp9s0f3u1`). To prevent Wi-Fi from hijacking default traffic while maintaining silent automatic failover, interface route metrics are strictly tiered.

* **Routing Architecture**:
  * **Ethernet (`Wired connection 1`)**: Metric `100` (Primary)
  * **Wi-Fi (`PLDTHOMEFIBR45010`)**: Metric `600` (Fallback)

* **Behavior**:
  * Outbound gateway traffic (`default via 192.168.1.1`) routes exclusively through `enp5s0` whenever plugged in.
  * Unplugging or link-loss on Ethernet causes the kernel to immediately fall back to the associated Wi-Fi interface without interrupting established socket states or requiring reconnect rituals.
  * Re-plugging Ethernet reinstates priority route metric `100` instantly.

* **Configuration Commands**:
  * `nmcli connection modify "Wired connection 1" ipv4.route-metric 100`
  * `nmcli connection modify "PLDTHOMEFIBR45010" ipv4.route-metric 600`

* **Verification**:
  * `ip route get 1.1.1.1` (Returns `dev enp5s0 src 192.168.1.44`)
