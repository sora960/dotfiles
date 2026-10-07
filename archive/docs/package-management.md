## Pacman Mirror, Package Cache, and Dependency Verification

**Date:** 2026-09-06

### Mirror Re-Ranking

Ran:

```bash
sudo cachyos-rate-mirrors
```

The tool successfully re-ranked both Arch and CachyOS repositories.

#### Arch Linux

1229 mirrors were discovered, with 291 remaining after protocol filtering. The top re-tested mirrors were:

| Rank | Mirror                       | Tested Speed |
| ---: | ---------------------------- | -----------: |
|    1 | `fastly.mirror.pkgbuild.com` |     6.5 MB/s |
|    2 | `mirror.osbeck.com`          |     5.9 MB/s |
|    3 | `mirrors.logal.dev`          |     5.8 MB/s |
|    4 | `mirror.xtom.com.hk`         |     5.7 MB/s |
|    5 | `mirror.keiminem.com`        |     4.5 MB/s |

The resulting list was written to:

```text
/etc/pacman.d/mirrorlist
```

#### CachyOS

28 mirrors were tested. The top re-tested mirrors were:

| Rank | Mirror                 | Tested Speed |
| ---: | ---------------------- | -----------: |
|    1 | `mirror.krfoss.org`    |     3.5 MB/s |
|    2 | `mirror5.krfoss.org`   |     3.3 MB/s |
|    3 | `mirror2.keiminem.com` |     3.3 MB/s |
|    4 | `mirror.keiminem.com`  |     3.0 MB/s |
|    5 | `cdn.lansing2600.org`  |   953.4 KB/s |

The resulting list was written to:

```text
/etc/pacman.d/cachyos-mirrorlist
```

### PHP Installation Incident

The first attempt to install PHP immediately after mirror ranking failed:

```bash
sudo pacman -S php
```

Pacman attempted to install:

```text
argon2-20190702-6.2
oniguruma-6.9.10-1.1
php-8.5.9-2
```

The PHP package itself was reported as up to date, but its detached signature could not be retrieved:

```text
error: failed retrieving file 'php-8.5.9-2-x86_64_v3.pkg.tar.zst.sig'
from mirror.krfoss.org : The requested URL returned error: 404
```

The transaction therefore failed:

```text
error: failed to commit transaction (failed to retrieve some files)
Errors occurred, no packages were upgraded.
```

This was a **repository mirror/package synchronization issue**, not a PHP dependency or installation failure.

### Package Database Refresh

Forced synchronization and system upgrade:

```bash
sudo pacman -Syyu
```

The operation completed successfully.

During synchronization, several PipeWire packages reported that the locally installed version was newer than the version currently present in the Arch `extra` repository:

```text
alsa-card-profiles
libpipewire
pipewire
pipewire-audio
pipewire-jack
pipewire-pulse
pipewire-session-manager
```

These were warnings only; no downgrade was performed.

The refresh resulted in four actual package upgrades:

```text
adwaita-fonts-51.0-2
archlinux-keyring-1:20260902-1
firefox-155.0.1-1
libxml2-2.15.4-1.1
```

All packages downloaded successfully, passed signature/integrity checks, and were installed successfully.

### PHP Installation Resolution

After the package database refresh, PHP was installed again:

```bash
sudo pacman -S php
```

Pacman now resolved:

```text
argon2-20190702-6.2
oniguruma-6.9.10-1.1
php-8.5.10-2
```

The PHP package downloaded successfully:

```text
php-8.5.10-2-x86_64_v3.pkg.tar.zst
```

All three packages passed:

* key verification
* package integrity verification
* file conflict checks
* disk-space checks

The transaction completed successfully.

**Conclusion:** The original PHP installation failure was caused by stale/inconsistent mirror state. Refreshing the package databases resolved the issue, and PHP 8.5.10-2 installed normally.

### Dependency Verification: `adwaita-fonts`

After the system upgrade:

```bash
pacman -Qi adwaita-fonts
```

confirmed:

```text
Name            : adwaita-fonts
Version         : 51.0-2
Installed From  : extra
Depends On      : None
Required By     : gsettings-desktop-schemas gtk3
Install Reason  : Installed as a dependency for another package
```

Therefore `adwaita-fonts` is **not an unnecessary package**. It is currently required by installed packages:

```text
gsettings-desktop-schemas
gtk3
```

It should not be removed as part of the lean-system cleanup.

### Orphan Check

Ran:

```bash
pacman -Qdt
```

Result:

```text
<no output>
```

Therefore there are currently **no packages identified by pacman as orphaned dependencies**.

### Pacman Cache Verification

Pacman's package cache was inspected:

```bash
ls -lh /var/cache/pacman/pkg/php-*
```

Current PHP cache contents:

```text
php-8.5.10-2-x86_64_v3.pkg.tar.zst
php-8.5.10-2-x86_64_v3.pkg.tar.zst.sig
php-8.5.9-2-x86_64_v3.pkg.tar.zst
```

The old PHP 8.5.9 package is still present:

```text
php-8.5.9-2-x86_64_v3.pkg.tar.zst
```

This is a **complete cached package**, not evidence of a partially installed or corrupted PHP transaction.

The failed transaction did not install PHP 8.5.9. The package remained only in the pacman cache.

The current cache size is:

```text
119M    /var/cache/pacman/pkg
```

The current PHP installation is 8.5.10-2; the older 8.5.9-2 package is retained solely as a cached previous package version.

### Final State

The package-management state after the incident is:

* Mirror lists successfully regenerated.
* Arch and CachyOS package databases successfully synchronized.
* Full system upgrade completed successfully.
* PHP 8.5.10-2 installed successfully.
* `argon2` and `oniguruma` installed as PHP dependencies.
* `adwaita-fonts` verified as required by `gsettings-desktop-schemas` and `gtk3`.
* `pacman -Qdt` reports no orphaned dependencies.
* Pacman cache contains the previous PHP 8.5.9-2 package.
* Pacman cache currently occupies 119 MiB.
* No package transaction remains partially installed.

**Status: RESOLVED**

