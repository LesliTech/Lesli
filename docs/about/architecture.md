# Architecture Overview

Lesli is built with a clear focus on **modularity**, **scalability**, and **maintainability**. It follows the principles of modern Rails architecture while introducing its own conventions to simplify the development of SaaS platforms.

At its core, Lesli provides a **modular structure** where new features and components are delivered through **Rails engines**. This approach ensures clean separation of concerns, easy maintenance, and flexibility to scale your application as needed.


<br/>

## Core Concepts

### Core Gem (Lesli)
The **Lesli core gem** is responsible for providing shared infrastructure, conventions, and utilities across your entire application. It offers:

- Configuration management
- Common helpers and components
- Shared domain models (when appropriate)
- Standardized generator tools
- Support for multi-tenancy (optional)

### Engines (Modules)
Modules in Lesli are **Rails engines** that can be developed and maintained independently. Each engine is isolated and encapsulates a specific domain or feature set. Examples of official engines include:

- **LesliShield** for roles, privileges, and user management
- **LesliDashboard** for dashboards and reporting tools

<br/>

Engines can include: 

- Their own models, controllers, views
- Migrations
- Assets (JavaScript, CSS)
- Services and background jobs
- API endpoints


<br/>

## High-Level Architecture

```
Your Rails App
├── Lesli Core (Gem)
│   ├── Configurations
│   ├── Utilities
│   └── Generators
│
├── Engines (Modules)
│   ├── LesliShield (Authentication / Roles)
│   ├── LesliDashboard (Dashboards / Reporting)
│   └── Custom Engines (Your features)
│
└── Shared Resources
    ├── Design System (Components, Bulma, SASS)
    ├── Database (PostgreSQL)
    └── API (Optional)
```


<br/>

## Key Technologies

| Layer          | Technology     |
|----------------|----------------|
| Backend        | Ruby on Rails   |
| Database       | PostgreSQL      |
| Frontend       | AlpineJS, Bulma |
| Styling        | SASS            |
| Authentication | Devise (via LesliShield) |


<br/>

## How It All Comes Together

1. **Your App** serves as the host Rails application.
2. **Lesli Core** provides the foundation: conventions, generators, and utilities.
3. **Engines** extend your app’s functionality in isolated, reusable modules.
4. **Frontend Components** are shared across modules via LesliView, LesliAssets gems.
5. **PostgreSQL** handles data persistence with clean isolation between core app and engines.

This modular design allows you to grow your SaaS product by simply adding or creating new engines as your needs evolve.

<br/>

## Architecture Diagram

```
+------------------------------------------------------------+
|                       Your Rails App                       |
|                                                            |
|  +---------------------+   +---------------------------+   |
|  |    Lesli Core Gem   |   |    Shared Frontend        |   |
|  |  (Configuration,    |   | (Bulma, SASS, Components) |   |
|  |   Utilities,        |   +---------------------------+   |
|  |   Generators)       |                                   |
|  +---------------------+                                   |
|                                                            |
|  +---------------------+   +---------------------------+   |
|  |   LesliShield       |   |      LesliDashboard       |   |
|  | (User Roles, Auth)  |   |  (Dashboards, Widgets)    |   |
|  +---------------------+   +---------------------------+   |
|                                                            |
|  +---------------------+                                   |
|  |  Custom Engines     |                                   |
|  | (Your Features)     |                                   |
|  +---------------------+                                   |
|                                                            |
|  Database: PostgreSQL                                      |
+------------------------------------------------------------+
```

<br/>

## Benefits of This Architecture

✅ Clean separation of concerns  
✅ Easy to extend and maintain  
✅ Scalable for growing SaaS products  
✅ Encourages best practices and consistency  
✅ Supports both monolithic and modular deployments

