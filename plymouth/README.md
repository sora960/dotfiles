# Plymouth Custom Theme Setup (`lucy-video`)

This guide outlines how to restore and activate the custom `lucy-video` Plymouth boot theme on Arch Linux / CachyOS after Plymouth has been removed or disabled.

---

## Prerequisites

Install Plymouth:

```bash
sudo pacman -S plymouth
```

---

## 1. Symlink the Theme

Create a symbolic link from your dotfiles to the system themes directory:

```bash
sudo ln -sf ~/dotfiles/plymouth/lucy-video /usr/share/plymouth/themes/lucy-video
```

---

## 2. Configure `mkinitcpio.conf`

Open the configuration:

```bash
sudo nvim /etc/mkinitcpio.conf
```

Ensure the `HOOKS` array includes `plymouth` immediately after `systemd` (or `base`):

```bash
HOOKS=(base systemd plymouth autodetect microcode modconf kms keyboard sd-vconsole block filesystems fsck)
```

---

## 3. Configure systemd-boot

Edit your boot entry:

```bash
sudo nvim /boot/loader/entries/cachyos.conf
```

Add the `splash` kernel parameter to the `options` line:

```text
options root=PARTUUID=cb564622-de6b-4145-b42a-1c48012ec031 rw quiet splash loglevel=3 rd.udev.log_level=3 systemd.show_status=auto fsck.mode=auto fsck.repair=yes
```

---

## 4. Set the Theme & Rebuild Initramfs

```bash
sudo plymouth-set-default-theme -R lucy-video
```

---

## 5. Reboot

```bash
sudo systemctl reboot
```

---

## Verify the Installation

Check the active theme:

```bash
plymouth-set-default-theme
```

It should output:

```text
lucy-video
```

Verify the README exists:

```bash
cat ~/dotfiles/plymouth/README.md
```
