# Developer Environment

Defines the development capabilities provided by the system for building, testing, and maintaining software projects.

This document records the **actual global development environment**. Project-specific frameworks, libraries, and dependencies remain managed by their respective project repositories.

---

## 1. Version Control

### Git

Git is the primary version-control system.

Used for:

* Source control
* Local repository management
* Branching and merging
* Commit history

---

## 2. GitHub Workflow

### GitHub CLI

GitHub CLI provides terminal-based access to GitHub workflows.

Used for:

* Repository management
* Issues
* Pull requests
* GitHub workflow from the terminal

---

## 3. Secure Remote Access

### OpenSSH

OpenSSH provides SSH connectivity and Git authentication.

Used for:

* SSH connections
* GitHub SSH authentication
* Secure remote access

---

## 4. PHP Development

### PHP

PHP provides the runtime required for PHP application development.

Used for:

* PHP application development
* Laravel development
* Running PHP applications and tooling

### Composer

Composer provides PHP dependency management.

Used for:

* Installing PHP dependencies
* Installing Laravel projects
* Managing project dependencies
* Running PHP development tooling

---

## 5. JavaScript / Frontend Development

The development environment provides a JavaScript runtime and package-management capability for projects requiring frontend tooling.

The current RMS stack uses:

* JavaScript runtime
* JavaScript package manager
* Vite
* Tailwind CSS

Frontend frameworks and libraries remain project-specific.

The project repository determines the exact frontend dependencies and versions.

---

## 6. Database Development

### PostgreSQL

PostgreSQL provides the relational database server for application development.

It is installed globally as a development service because current projects, including the Rental Management System (RMS), require PostgreSQL.

Used for:

* Relational database development
* Application development and testing
* Local database-backed projects
* PostgreSQL client/CLI access

The PostgreSQL server is managed by the system through `systemd`.

Verify the installation with:

```bash
psql --version
```

Manage the PostgreSQL service with:

```bash
sudo systemctl status postgresql
```

Start the service when required:

```bash
sudo systemctl start postgresql
```

Enable PostgreSQL to start automatically with the system:

```bash
sudo systemctl enable postgresql
```

Project-specific database configuration remains inside the project repository's environment configuration.

---

## 7. Testing

Testing tools remain primarily project-specific.

For PHP and Laravel projects, the standard testing capability is provided through the project's Composer dependencies.

Expected capabilities include:

* Unit testing
* Feature testing
* Integration/application testing
* Database testing

For the current Laravel-based development stack, PHPUnit and Laravel's testing facilities are used through the project rather than installed globally.

---

## 8. Development Infrastructure

Additional infrastructure is installed only when an actual project requires it.

Potential capabilities include:

* Containers
* Redis
* Background job infrastructure
* Message brokers
* Additional database systems
* Object storage
* Other local development services

These are **not part of the permanent base development environment unless a concrete requirement justifies them.**

---

## 9. Project Dependencies

Frameworks, libraries, and application-specific tooling belong to individual projects.

Examples include:

```text
Laravel
Livewire
PHPUnit
Laravel packages
Tailwind CSS
Vite
Frontend libraries
Application-specific libraries
```

These dependencies should normally be declared in the project and installed through the appropriate dependency-management system.

Global installation should be avoided when the software only serves one project.

---

## 10. Current Development Stack

The current development environment supports the following application stack:

```text
Version Control
    ├── Git
    └── GitHub CLI

Remote Access
    └── OpenSSH

PHP Development
    ├── PHP
    └── Composer

Frontend Development
    ├── JavaScript runtime
    ├── JavaScript package manager
    ├── Vite
    └── Tailwind CSS

Database Development
    └── PostgreSQL

Testing
    └── Project-specific testing tools
```

The current RMS application stack is:

```text
Backend
    └── PHP

Framework
    └── Laravel

Database
    └── PostgreSQL

Frontend
    ├── Blade
    ├── Livewire
    └── Tailwind CSS

Asset Bundling
    └── Vite

Authentication / Authorization
    └── Laravel authentication and authorization

Testing
    └── PHPUnit + Laravel testing

Dependency Management
    └── Composer
```

The application stack describes project technology choices. It does not imply that every framework or library is installed globally.

---

## 11. Installation Rule

Development tooling follows this process:

```text
Requirement
    ↓
Select appropriate tool
    ↓
Check whether already installed
    ↓
Install
    ↓
Verify
    ↓
Use in an actual project
    ↓
Document if globally maintained
```

A tool becomes permanent global tooling only when it provides genuine value across projects or is required as part of the system-wide development environment.

Project-specific dependencies remain inside their respective repositories.

---

## 12. Environment Verification

The development environment should be verifiable through the installed tools themselves.

Examples:

```bash
git --version
gh --version
ssh -V
php --version
composer --version
psql --version
```

Project-specific tooling should be verified from within the project repository.

For example:

```bash
php artisan --version
php artisan test
```

---

## 13. Scope

This document covers **global development capabilities provided by the system**.

It does not serve as:

* A list of every installed package.
* A project dependency manifest.
* A Laravel application specification.
* A record of individual project configuration.
* A replacement for project documentation.

System packages and their operational history belong in the appropriate system documentation.

Project frameworks, libraries, configuration, and dependencies belong in the project repository.

---

## 14. Maintenance

The development environment is maintained according to actual project requirements.

When a new project introduces a requirement:

```text
Project Requirement
        ↓
Determine whether capability already exists
        ↓
Use existing capability
        ↓
If absent, evaluate installation
        ↓
Install and verify
        ↓
Determine whether it is global or project-specific
        ↓
Update documentation when appropriate
```

This prevents unnecessary global tooling while ensuring the system can support the projects being actively developed.

