# Lesli Ecosystem

Lesli is built as a modular platform.

Instead of concentrating all functionality in a single codebase, Lesli extends through **Ruby on Rails engines**. These engines, also referred to as modules, allow you to add new capabilities, organize domains more clearly, and grow your application without turning it into a monolith.

The Lesli team maintains a growing ecosystem of production-ready modules, most of them open source, designed to accelerate the development of real SaaS products.

---

## Why the Ecosystem Matters

The ecosystem is one of Lesli’s biggest strengths.

It allows development teams to:

* Add features without rebuilding common SaaS functionality from scratch
* Keep domains isolated through independent modules
* Reuse shared infrastructure and conventions across products
* Extend the platform with custom engines when product-specific functionality is needed

In practice, this means you can start with the Lesli core and expand your application as your product evolves.

---

## Collections

To make the ecosystem easier to navigate, modules are grouped into **collections**. A collection represents a category of functionality or a business domain commonly found in SaaS applications.

### Available Collections

1. **Administration**
2. **Sales and Marketing**
3. **Productivity and Teamwork**
4. **Finance**
5. **Analytics**
6. **Intelligence**
7. **IT and Help Desk**
8. **Security and Privacy**
9. **Integrations**

Collections make it easier to identify which modules may be relevant to your application, team, or industry.

---

## Official Modules

Lesli currently has **45 modules planned**, with **9 production-ready modules** already available.

| Code | Module             | Description                                             |
| ---- | ------------------ | ------------------------------------------------------- |
| 0101 | **LesliAdmin**     | Administration area for managing core platform settings |
| 0301 | **LesliCalendar**  | Unified calendar application                            |
| 0305 | **LesliLetter**    | Notes and notebooks                                     |
| 0306 | **LesliDashboard** | Dashboards and business insights                        |
| 0308 | **LesliBell**      | Notifications and alerts                                |
| 0502 | **LesliAudit**     | System analytics and activity tracking                  |
| 0702 | **LesliSupport**   | Support ticket management                               |
| 0801 | **LesliShield**    | Authentication, authorization, roles, and privileges    |
| 0901 | **LesliBabel**     | Translation management                                  |

You are not limited to official modules. Lesli also allows you to create and integrate your own custom engines when your application requires domain-specific functionality.

---

## How the Ecosystem Fits Together

At the center of the ecosystem is the **Lesli core**, which provides the shared framework layer, utilities, generators, and conventions.

On top of that foundation, official modules and custom modules can be mounted into your host Rails application through the Rails engine architecture. This creates a flexible model where shared infrastructure stays centralized, while features remain modular and easier to evolve.

```text
Lesli Core
├── Shared conventions
├── Utilities
├── Generators
└── Framework services

Official Modules
├── Authentication and security
├── Dashboards and reporting
├── Collaboration and productivity
└── Business capabilities

Your Custom Modules
└── Product-specific domains and features

Host Rails Application
└── Integrates core and modules into one SaaS product
```

---

## Summary

The Lesli ecosystem is designed to help teams move faster by combining a shared Rails foundation with a growing library of reusable modules.

It gives you the flexibility to adopt only what you need, extend the platform where necessary, and continue building on a structure that stays organized as your product grows.
