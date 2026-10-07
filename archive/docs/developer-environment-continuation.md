# Developer Environment — Finalization Continuation

This document records development-environment work that remains to be completed before `docs/developer-environment.md` can be considered finalized.

The purpose of this continuation is to avoid repeatedly modifying the main developer-environment document while project requirements are still being implemented and verified.

---

## 1. Current State

The global development environment currently provides:

* Git
* GitHub CLI
* OpenSSH
* PHP
* Composer
* PostgreSQL

PostgreSQL was installed as a global development capability after the Rental Management System (RMS) established PostgreSQL as its database requirement.

---

## 2. RMS Frontend Tooling

The RMS technical stack currently specifies:

```text
Frontend
    ├── Laravel Blade
    ├── Livewire
    └── Tailwind CSS

Asset Bundling
    └── Vite
```

These capabilities have **not yet been installed or verified** in the development environment.

They should not be documented as installed global tooling until their actual installation and scope have been determined.

---

## 3. JavaScript Runtime and Package Manager

The development environment still needs a concrete JavaScript runtime and package-management solution.

The selection must be based on the actual RMS implementation requirements.

Before updating `developer-environment.md`:

1. Select the runtime.
2. Select the package manager.
3. Install it.
4. Verify it.
5. Determine whether it should be global system tooling or project-specific.
6. Record the final decision in the main developer-environment documentation.

Do not install multiple runtimes or package managers without a concrete requirement.

---

## 4. Laravel Frontend Dependencies

The following RMS dependencies still need to be established through the actual Laravel project:

```text
Laravel
Livewire
Blade
Tailwind CSS
Vite
```

These should be installed and verified as part of RMS project initialization rather than prematurely treated as globally installed system software.

Their final scope must be determined before the developer-environment documentation is finalized.

---

## 5. Authentication

RMS requires authentication and authorization.

The exact Laravel authentication implementation has not yet been installed or verified.

Determine the appropriate current Laravel authentication solution during project initialization.

After implementation:

* Verify authentication works.
* Verify authorization requirements.
* Determine which components are project-specific.
* Keep project-specific dependencies inside RMS.

---

## 6. Testing

RMS requires automated testing for critical business workflows.

The project currently intends to use:

```text
PHPUnit
Laravel Testing
```

Testing dependencies should be installed through the RMS project's dependency-management system.

Do not install PHPUnit globally unless a separate cross-project requirement justifies it.

---

## 7. Environment Finalization Checklist

Before revisiting `docs/developer-environment.md`, verify:

```text
Global Development Environment
    ├── Git                         ✓
    ├── GitHub CLI                  ✓
    ├── OpenSSH                     ✓
    ├── PHP                         ✓
    ├── Composer                    ✓
    └── PostgreSQL                  ✓

RMS Development Stack
    ├── Laravel                     [ ]
    ├── Blade                       [ ]
    ├── Livewire                    [ ]
    ├── Tailwind CSS                [ ]
    ├── Vite                        [ ]
    ├── JavaScript runtime          [ ]
    ├── JavaScript package manager  [ ]
    ├── Authentication              [ ]
    └── Testing                     [ ]
```

---

## 8. Finalization Rule

Do not repeatedly modify the main developer-environment documentation while these requirements remain unresolved.

Once RMS has been initialized and the required tooling has been installed and verified:

```text
Verify actual environment
        ↓
Separate global tooling from project dependencies
        ↓
Update developer-environment.md once
        ↓
Verify documentation against actual system state
        ↓
Finalize
```

Until then, this document serves as the continuation point for development-environment finalization.


# RMS — Core Development Tool Installation

Records core development tools installed while preparing the Rental Management System environment.

This document is a temporary installation record. It will be merged into the appropriate system documentation later.

---

## Bun

Installed globally through the Arch/CachyOS package manager:

```bash
sudo pacman -S bun
```

Installed version:

```text
Bun 1.4.0
```

Verification:

```bash
bun --version
```

Result:

```text
1.4.0
```

Purpose:

* JavaScript runtime
* JavaScript package manager
* Frontend dependency management
* Vite development tooling

Scope:

```text
Global development environment
```

---

## Laravel Installer

Installed globally through Composer:

```bash
composer global require laravel/installer
```

Installed version:

```text
Laravel Installer 5.32.0
```

Verification:

```bash
laravel --version
```

Result:

```text
Laravel Installer 5.32.0
```

Purpose:

* Create and initialize Laravel applications
* Provide the `laravel` command-line tool

Scope:

```text
Global development environment
```

---

## Composer Global Binary PATH

Composer's global executable directory was identified with:

```bash
composer global config bin-dir --absolute
```

Result:

```text
/home/lucy/.config/composer/vendor/bin
```

The directory was added to Bash's `PATH`:

```bash
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.bashrc
```

The current shell was reloaded:

```bash
source ~/.bashrc
```

This allows Composer-installed global executables such as `laravel` to be invoked directly.

Verification:

```bash
laravel --version
```

Result:

```text
Laravel Installer 5.32.0
```

---

## Installation Summary

| Component                   | Version | Scope      | Status   |
| --------------------------- | ------: | ---------- | -------- |
| Bun                         |   1.4.0 | Global     | Verified |
| Laravel Installer           |  5.32.0 | Global     | Verified |
| Composer global binary PATH |       — | User shell | Verified |

---

## Next Step

The core tooling required to initialize the Laravel project is now available.

RMS project initialization can proceed.

No project-specific Laravel, Livewire, Tailwind, Vite, authentication, or testing dependencies have been installed yet.

