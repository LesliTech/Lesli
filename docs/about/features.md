# Framework Features

Lesli combines a shared Rails foundation with focused engines and supporting gems. Together, these layers provide the capabilities commonly needed to build and operate SaaS products without placing every concern inside one application.

This page is the framework-level feature overview. Detailed configuration and implementation guidance belongs in the documentation for the core, engine, or gem that provides each capability.

> **Feature availability:** Available features depend on the engines and gems installed in your application. Lesli Core provides the foundation; optional modules extend it with specialized capabilities.

---

## Feature Map

| Area | Capabilities | Primary layer |
| ---- | ------------ | ------------- |
| Architecture | Modular Rails engines, shared conventions, generators | Lesli Core |
| Identity and access | Authentication, roles, privileges, access control | LesliShield |
| Auditing and history | Activities, version history, system and request auditing | Lesli Core and LesliAudit |
| Files and resources | Attachments and reusable resource structures | Lesli Core |
| Localization | Application translations and translation management | Lesli Core and LesliBabel |
| Presentation | Themes, design tokens, and shared client styling | Lesli Core and LesliAssets |

---

## Modular Architecture

Lesli uses standard Rails engines to keep business domains independent. Applications can start with the core framework and add official or custom engines as requirements grow.

This approach keeps shared infrastructure centralized while allowing each module to own its models, controllers, views, migrations, services, and API endpoints.

Read the [architecture overview](/engines/lesli/about/architecture/) for the complete structural model.

---

## Authentication and Permissions

LesliShield extends the framework with account authentication, user sessions, roles, privileges, and detailed access control. Applications can define which actions and resources are available to each role without duplicating authorization logic across modules.

Authentication and authorization are kept in a dedicated engine so applications can adopt the security layer they need while preserving the modular framework boundary.

---

## Activity and Version History

Reusable activity and version structures make it possible to track meaningful changes to application resources. LesliAudit adds broader system, request, device, and user-level auditing where deeper operational visibility is required.

Together, these capabilities support traceability, troubleshooting, compliance workflows, and recovery of previous resource state.

---

## Attachments

The framework provides reusable attachment structures that engines can associate with their own resources. This gives applications a consistent way to manage files without rebuilding attachment behavior for every business domain.

---

## Localization and Theming

Lesli applications can customize language, date and time formats, visual themes, and shared interface tokens. LesliBabel adds translation-management workflows, while LesliAssets provides shared design resources for consistent web, desktop, and mobile experiences.

See [framework configuration](/engines/lesli/start/configuration/) for the core localization and theme options.

For the available official modules, visit the [Lesli ecosystem](/engines/lesli/about/ecosystem/).

---

## Feature Ownership

Framework documentation explains how capabilities fit together across the Lesli platform. The providing engine or gem remains the source of truth for installation, configuration, APIs, permissions, and implementation details.

This separation keeps the framework overview easy to navigate while allowing every module to document its behavior independently.
