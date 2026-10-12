# Getting Started

Add Lesli to a Rails application, prepare its database, and confirm the shared framework is running. Start with **Lesli Core**; add only the Engines your product needs.

## Requirements

* Ruby **3.2 or newer**
* Rails **8.1**
* SQLite, included with a default Rails application, or PostgreSQL

Node.js 20.x is optional. You only need it when developing or rebuilding frontend assets from source; released Lesli gems include compiled assets.

## Installation

### 1. Create a Rails Application

Create a new host application, or continue from an existing Rails 8.1 application:

```shell
rails new my_app
cd my_app
```

### 2. Install Lesli Core

Add the core framework and run its installation generator:

```shell
bundle add lesli
bin/rails generate lesli:install
```

The generator makes two changes to the host application:

* Creates `config/initializers/lesli.rb` for framework configuration.
* Adds `Lesli::Router.mount(self)` to `config/routes.rb`.

See [Install Lesli Core](/engines/lesli/start/cli-commands/#install-lesli-core) for the generator's options and overwrite behavior.

Prepare the database and Lesli resources:

```shell
bin/rails lesli:db:prepare
```

This command runs Rails `db:prepare`, builds the controller and action index from the application routes, initializes installed Engines for existing accounts, runs setup tasks for supported Engines, and prints the Lesli system status. It does **not** load seed data. See [Prepare and Configure](/engines/lesli/start/cli-commands/#prepare-and-configure) for its complete sequence and production considerations.

To confirm which Lesli components are loaded at any time, run:

```shell
bin/rails lesli:status
```

The [status command reference](/engines/lesli/start/cli-commands/#show-lesli-status) describes the component information included in this report.

### 3. Add Optional Engines

Lesli Core does not install every Lesli feature. Engines are separate gems that add capabilities such as authentication and authorization, dashboards, notifications, translations, or support workflows. Install only the Engines your application needs.

For example, add **LesliShield** for its dedicated login experience, roles, and privileges:

```shell
bundle add lesli_shield
bin/rails lesli:db:prepare
```

The shared Lesli router mounts installed Engines automatically. Run `lesli:db:prepare` after adding an Engine so its database and per-account setup can be applied. Each Engine may have additional requirements, so follow its installation page in the [Engine catalog](/engines/).

## Your First Application

Start Rails:

```shell
bin/rails server
```

Open [http://127.0.0.1:3000](http://127.0.0.1:3000). With Lesli Core installed, the application root displays the Lesli welcome screen. You should also have:

* A Lesli initializer at `config/initializers/lesli.rb`.
* The shared Lesli router mounted in `config/routes.rb`.
* A prepared database and a status report listing the installed Lesli components.

Engine-specific screens are available only after installing their Engines. For example, `/login` is provided by LesliShield; it is not the default Core landing page.

Seed data is optional and separate from database preparation. When an installed Engine instructs you to load its seeds, run:

```shell
bin/rails lesli:db:seed
```

Review [Load Seed Data](/engines/lesli/start/cli-commands/#load-seed-data) before running seeds against persistent environments.

## What's Next?

* Build a complete host-application feature in [Build Your First SaaS with Lesli](/engines/lesli/tutorials/first-saas/).
* Understand how the host application, Core, Engines, and shared resources fit together in the [architecture overview](/engines/lesli/about/architecture/).
* Choose optional capabilities from the [Engine catalog](/engines/).
* Explore reusable libraries and development tools in the [Gem catalog](/gems/).
* Review [Lesli configuration](/engines/lesli/start/configuration/) before customizing framework behavior.
* Use the [CLI command reference](/engines/lesli/start/cli-commands/) for Core tasks, generators, side effects, and environment restrictions.
* Try the complete product in the [online demo and demo guide](/engines/lesli/about/demo/).

For local framework development or contributions, use the [development installation guide](/engines/lesli/start/development/).
