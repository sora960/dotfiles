# System Baseline

Defines the intended architecture, ownership, and maintenance principles of the system.

This document describes **what the system is intended to be**.

It does not serve as a package inventory or change history.

---

## 1. System Identity

**Operating System:** CachyOS / Arch Linux

**Desktop:** Hyprland

**Display Protocol:** Wayland

**Login:** Ly (TUI Display Manager) / UWSM Session Management

**Configuration Repository:** `~/dotfiles`

The system is managed as a Git-controlled configuration environment.

---

## 2. Configuration Ownership

The `~/dotfiles` repository is the source of truth for user-managed system configuration.

| Area                   | Source of Truth       |
| ---------------------- | --------------------- |
| Hyprland configuration | `~/dotfiles/hypr/`    |
| User scripts           | `~/dotfiles/scripts/` |
| System documentation   | `~/dotfiles/docs/`    |

Changes to managed configuration should be made in the repository rather than directly modifying generated or copied files elsewhere.

---

## 3. System Architecture

The system is organized into distinct layers:

```text
Operating System
        │
        ├── Kernel
        ├── Hardware support
        ├── Drivers
        ├── Networking
        └── System services
                │
                ▼
Desktop Environment
        │
        ├── Wayland
        ├── Hyprland
        └── Desktop utilities
                │
                ▼
User Environment
        │
        ├── Shell
        ├── Scripts
        ├── Applications
        └── User configuration
                │
                ▼
Developer Environment
        │
        ├── Git
        ├── GitHub tooling
        ├── Programming runtimes
        ├── Package managers
        └── Build tooling
                │
                ▼
Projects
        │
        ├── Frameworks
        ├── Project dependencies
        ├── Databases
        └── Project-specific services
```

Each layer should have a clear ownership boundary.

---

## 4. Package Management

System packages are managed through the appropriate package-management mechanism.

### Primary Package Manager

```text
pacman
```

### AUR

AUR packages are managed through:

```text
paru
```

### Package Principles

* Prefer official Arch/CachyOS repositories.
* Use the AUR only when necessary.
* Do not install software speculatively.
* Do not remove packages solely because they appear unused without establishing their purpose and dependency relationships.
* Verify package state after significant package-management operations.
* Keep package-management incidents and maintenance actions in `system-changelog.md` or the appropriate operational documentation.

The goal is a **known and intentional system**, not an artificially minimized package count.

---

## 5. Development Environment

The global development environment is documented separately in:

```text
docs/developer-environment.md
```

That document defines:

* globally installed development tools
* language runtimes
* package managers
* development infrastructure
* global versus project-specific dependencies
* development-environment verification

The system baseline establishes the boundary between the core system and the development environment.

---

## 6. Script Management

User-managed executable utilities are stored directly in:

```text
~/dotfiles/scripts/
```

This directory is the source of truth for system scripts.

Scripts are exposed to the appropriate execution environments through the mechanisms documented in:

```text
docs/scripts-architecture.md
```

Scripts must not be duplicated across unrelated locations without a documented reason.

---

## 7. Documentation Structure

Documentation is divided according to purpose.

| Document                        | Purpose                                        |
| ------------------------------- | ---------------------------------------------- |
| `system-baseline.md`            | Intended system architecture and rules         |
| `system-changelog.md`           | Historical record of significant changes       |
| `developer-environment.md`      | Development environment baseline and inventory |
| `package-management.md`         | Package-management operations and incidents    |
| `scripts-architecture.md`       | Script ownership and execution routing         |
| `font-configuration.md`         | Font configuration and requirements            |
| `eink-shader-implementation.md` | E-ink shader implementation details            |
| `audit.md`                      | System/package audit findings                  |

A document should have one primary responsibility.

---

## 8. Maintenance Model

System changes follow this lifecycle:

```text
Requirement
    ↓
Determine intended change
    ↓
Execute change
    ↓
Observe result
    ↓
Diagnose problems
    ↓
Resolve problems
    ↓
Verify final state
    ↓
Record significant change
    ↓
Review Git changes
    ↓
Commit
```

Not every trivial command requires a changelog entry.

Significant system changes, configuration changes, incidents, and maintenance operations should be recorded when they provide useful historical context.

---

## 9. State vs History

The system distinguishes between **state** and **history**.

### Desired State

Defined by:

```text
system-baseline.md
developer-environment.md
```

These documents describe what the system is intended to provide.

### Current State

Established through direct inspection and verification of the machine.

Examples:

```bash
pacman -Q
pacman -Qi <package>
systemctl
git status
<command> --version
```

Current machine state should not be manually copied into documentation when it can be reliably obtained from the system.

### Historical State

Recorded in:

```text
system-changelog.md
```

The changelog explains how the system arrived at its current state.

---

## 10. Verification

Significant changes must be verified against their intended result.

Verification should establish facts from the system itself rather than relying solely on the success message from an installation or configuration command.

Examples:

```bash
pacman -Qi <package>
<command> --version
systemctl status <service>
git diff
git status
```

The verification method depends on the change being performed.

---

## 11. Git as System History

The `~/dotfiles` Git repository preserves the history of managed configuration and documentation.

Git answers:

> What changed in the repository?

The system changelog answers:

> Why did the system change, what happened during the change, and what was the final verified result?

These are complementary rather than interchangeable.

---

## 12. Core Maintenance Principles

### Intentionality

Every persistent system component should have a known purpose.

### Ownership

Every managed configuration or executable should have a clearly defined source of truth.

### Verification

A successful command does not automatically establish that the intended system state was achieved.

### Traceability

Significant changes should be understandable after the fact.

### Separation

Desired state, current state, and historical state should not be unnecessarily mixed.

### Minimal Complexity

Automation should be introduced only when it removes recurring work or improves reliability.

Do not build automation merely because a task can be automated.

---

## 13. System Management Rule

The system follows this model:

```text
Baseline
    ↓
defines intent

Machine
    ↓
contains actual state

Verification
    ↓
establishes truth

Changelog
    ↓
preserves operational history

Git
    ↓
preserves repository history
```

* **Baseline defines intent.**
* **State describes reality.**
* **Verification establishes truth.**
* **Changelog preserves operational history.**
* **Git preserves configuration history.**

