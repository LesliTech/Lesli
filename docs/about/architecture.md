# Architecture Overview

Lesli is built as a modular Ruby on Rails architecture for teams that need to ship SaaS products without sacrificing long-term maintainability.

Instead of concentrating every concern inside a single application layer, Lesli organizes functionality through a core framework and a growing set of Rails engines. This structure keeps domains isolated, reduces coupling, and makes it easier to evolve your product over time.

More than a starter kit, Lesli provides a foundation for building software that can grow in scope, team size, and complexity while preserving consistency across the codebase.

---

## Architectural Model

Lesli is based on two main layers:

### Lesli Core

The **Lesli core gem** provides the shared foundation of the framework. It includes the conventions, utilities, and framework-level behaviors used across the system.

Typical responsibilities of the core include:

* Configuration management
* Shared helpers and reusable components
* Generator tooling and developer workflows
* Common framework services and conventions
* Optional multi-tenant support

The goal of the core is to provide a stable base so every application and module built on Lesli follows the same architectural model.

### Engines and Modules

Lesli extends functionality through **Rails engines**. Each engine encapsulates a specific domain and can be developed, maintained, and evolved independently.

Official engines may cover areas such as authentication, dashboards, notifications, support, translations, or other business capabilities. Custom engines can also be created to model product-specific domains.

Each engine can include its own:

* Models, controllers, and views
* Database migrations
* Stylesheets and JavaScript assets
* Services and background jobs
* API endpoints

This approach allows new capabilities to be added without forcing all functionality into a single monolithic structure.

---

## How Lesli Fits Into Your Application

Your Rails application acts as the host system.

Lesli Core provides the shared framework layer, while engines plug in isolated functionality on top of that foundation. Shared frontend resources and conventions keep the experience consistent across modules, while the host application remains free to implement product-specific workflows and business rules.

This separation helps teams keep custom code focused on what makes their software different, instead of rebuilding common infrastructure over and over again.

---

## High-Level Structure

```text
Your Rails App
├── Lesli Core
│   ├── Configuration
│   ├── Utilities
│   ├── Generators
│   └── Shared framework conventions
│
├── Official and Custom Engines
│   ├── Authentication / Roles
│   ├── Dashboards / Reporting
│   ├── Notifications / Collaboration
│   └── Product-specific features
│
└── Shared Resources
    ├── Frontend assets and components
    ├── Database layer
    └── Optional API layer
```

---

## Technology Foundation

| Layer          | Technology                                   |
| -------------- | -------------------------------------------- |
| Backend        | Ruby on Rails                                |
| Database       | PostgreSQL / SQLite                          |
| Frontend       | Hotwire, Alpine.js, Bulma                    |
| Styling        | Sass                                         |
| Authentication | Devise-based integration through LesliShield |

---

## Why This Architecture Matters

Lesli’s architecture is designed to support real SaaS products over the long term.

It helps development teams:

* Keep domains isolated and easier to maintain
* Add new capabilities through engines instead of rewriting core application code
* Reuse infrastructure and shared conventions across projects
* Reduce coupling between business domains
* Scale the system without losing consistency

In practice, this means teams can move faster in the short term while preserving architectural clarity as the product grows.

---

## Architecture Diagram

<img alt="Lesli architecture" src="../images/lesli.excalidraw.svg" />

---

## Summary

Lesli combines a shared Rails foundation with a modular engine-based architecture to help teams build serious SaaS applications with more structure, less duplication, and greater long-term flexibility.

It is designed for products that need to evolve — not just launch.
