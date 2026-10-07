# System Changelog

Record of significant system changes, maintenance actions, problems, resolutions, and verified outcomes.

---

## YYYY-MM-DD — <Change>

**Reason:** Why was this change necessary?

**Action:** What was changed?

**Problem:** What went wrong? `None` if nothing.

**Resolution:** How was it fixed? `None` if nothing.

**Verification:** How was the result verified?

**Result:** Final system state.

**Status:** Verified

---

## 2026-09-06 — Login Architecture Migration: Agetty to Ly TUI Display Manager

**Reason:** Establish a clean, lightweight, single-user login workflow into Hyprland (managed via UWSM) that caches the username and focuses the password prompt, while eliminating manual shell autostart hooks, failed autologin drop-ins, and orphaned boot service remnants.

**Action:**
* Removed `/etc/systemd/system/getty@tty1.service.d/autologin.conf` and reloaded systemd daemon to restore default agetty behavior on TTY1.
* Removed conditional UWSM launch block (`uwsm check may-start && exec uwsm start hyprland.desktop`) from `~/.bash_profile`.
* Installed `ly` package (`/usr/bin/ly-dm`) via pacman.
* Configured `/etc/ly/config.ini` with `save = true` and `default_input = password`.
* Enabled `ly@tty2.service` to preserve TTY1 for system boot messages and avoid visual clobbering.
* Removed orphaned drop-in directory `/etc/systemd/system/plymouth-quit.service.d/` (`delay.conf`) left over from prior Plymouth package removal.

**Problem:**
* Attempting autologin via `agetty@tty1.service.d` override caused boot races and failed clean startup into UWSM.
* Untracked drop-in `/etc/systemd/system/plymouth-quit.service.d` remained in systemd after `plymouth` package was uninstalled.

**Resolution:**
* Transitioned session initialization responsibility from shell profile/agetty to `ly-dm` reading `/usr/share/wayland-sessions/hyprland-uwsm.desktop`.
* Deleted `/etc/systemd/system/plymouth-quit.service.d` and ran `systemctl daemon-reload`.

**Verification:**
* `systemctl is-enabled ly@tty2.service` returned `enabled`.
* `ls -d /etc/systemd/system/*.service.d` verified zero orphaned drop-in directories.
* `cat ~/.bash_profile` verified clean state containing only environment variables and `.bashrc` sourcing.
* `grep -E "^(save|default_input)\b" /etc/ly/config.ini` confirmed `save = true` and `default_input = password`.

**Result:** System boots with system logs on TTY1, hands off to `ly` on TTY2 with cached username and password box focused, and directly launches `hyprland-uwsm.desktop`.

**Status:** Verified
