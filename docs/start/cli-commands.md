# CLI Commands

Lesli Core adds Rails generators and Rake tasks to the host application. Run the commands in this reference from the relevant application or engine root and prefer `bin/rails` so the project's locked Rails and gem versions are used.

Commands under `lesli:` are provided by Lesli Core. Commands such as `server`, `db:migrate`, and `credentials:edit` are standard Rails commands and are outside this reference.

---

## Overview

| Command | Purpose | Changes files or data? |
| ------- | ------- | ---------------------- |
| `bin/rails generate lesli:install` | Mounts Lesli and creates its initializer | Yes: routes and initializer |
| `bin/rails lesli:install:migrations` | Copies Lesli Core migrations into the host application | Yes: migration files |
| `bin/rails lesli:db:prepare` | Prepares the database and configures installed Lesli modules | Yes: schema and records |
| `bin/rails lesli:db:seed` | Loads engine and host-application seeds | Yes: application data |
| `bin/rails lesli:db:rebuild` | Replaces and rebuilds the current database | **Destructive** |
| `bin/rails lesli:resources:build` | Registers controllers and actions from the current routes | Yes: Lesli resource records |
| `bin/rails lesli:status` | Prints the environment and installed Lesli components | No |
| `bin/rails lesli:dev:welcome` | Prints spacing followed by the Lesli status report | No |

Use `bin/rails -T lesli` to see the Lesli tasks loaded by the current application. Optional engines may add their own tasks; consult that engine's documentation before running them.

---

## Installation & Setup

### Install Lesli Core

```shell
bin/rails generate lesli:install
```

**Purpose:** Installs the minimum host-application integration for Lesli Core.

**Arguments:** None.

**Side effects:**

* Adds `Lesli::Router.mount(self)` to `config/routes.rb`.
* Creates `config/initializers/lesli.rb` with a minimal `Lesli.configure` block.

Run this generator once after adding the `lesli` gem. Review an existing initializer before using `--force`, because that option can overwrite application configuration.

The generator exposes the standard Rails runtime options:

| Option | Behavior |
| ------ | -------- |
| `-p`, `--pretend` | Shows the proposed changes without writing them |
| `-f`, `--force` | Overwrites files that already exist |
| `-s`, `--skip` | Skips files that already exist |
| `-q`, `--quiet` | Suppresses generator status output |
| `--skip-namespace` | Skips Rails' automatic namespace handling for isolated engines |
| `--skip-collision-check` | Skips Rails' constant-collision check |

Inspect changes safely before installation with:

```shell
bin/rails generate lesli:install --pretend
```

### Copy Lesli Core Migrations

```shell
bin/rails lesli:install:migrations
```

**Purpose:** Copies missing migration files from Lesli Core into the host application's migration directory.

**Arguments and options:** The Lesli task defines no positional arguments or custom command-line options.

**Side effects:** Creates migration files in the host application. Rails skips an engine migration when a migration with the same name already exists.

This is a Rails-provided engine task, not a custom Lesli implementation. Lesli Core also adds its engine migration path to the host application, so the standard Lesli installation flow can use `lesli:db:prepare` without copying the files. Use the copy task only when the application intentionally keeps engine migrations in its own source tree.

---

## Database Management

All database commands load the Rails environment and operate on the active database configuration. They define no custom arguments or options. Use the standard `RAILS_ENV` variable when an environment must be explicit:

```shell
RAILS_ENV=production bin/rails lesli:db:prepare
```

### Prepare and Configure

```shell
bin/rails lesli:db:prepare
```

**Purpose:** Applies the normal Rails database preparation flow and initializes Lesli for the current application.

It performs these operations:

1. Invokes Rails `db:prepare`.
2. Builds the Lesli controller and action resource index from the current routes.
3. Initializes core and installed-engine records for every existing Lesli account.
4. Synchronizes privileges when LesliShield is loaded.
5. Scans and imports translations when LesliBabel is loaded.
6. Prints `lesli:status`.

The task does not load seed data. Run it after installing Lesli, adding an engine, or deploying schema and route changes. It has no production guard and writes schema and application records, so review migrations and use the application's normal deployment safeguards.

### Load Seed Data

```shell
bin/rails lesli:db:seed
```

**Purpose:** Loads seed files for each installed Lesli engine and then invokes the host application's Rails `db:seed` task.

**Side effects:** Creates or updates whatever records the installed engines and host application define in their seed files, then prints `lesli:status`. There is no production restriction. Review every active seed file before running this command against persistent data; Core seed output may include initial user credentials.

See [Database Tasks and Seeders](/engines/lesli/database/seeders/) for seed order, idempotency, and production guidance.

### Rebuild the Database

```shell
bin/rails lesli:db:rebuild
```

> **Warning:** This command permanently deletes the current database data. Use it only with a disposable development or test database.

**Purpose:** Recreates a complete Lesli database from migrations and seeds.

It performs these operations:

1. Invokes Rails `db:drop`.
2. Deletes `db/schema.rb` when that file exists.
3. Invokes Rails `db:prepare`.
4. Loads Lesli engine and host-application seeds.
5. Builds resources and initializes accounts and installed engines.
6. Prints the status report.

The task raises an error when `Rails.env.production?` is true. That guard does not protect a database reached through a misconfigured development or test environment; verify the active database before running it.

### Build the Resource Index

```shell
bin/rails lesli:resources:build
```

**Purpose:** Scans routes from the host application and installed engines, then creates or updates the corresponding `Lesli::Resource` controller and action records.

Run it after adding or changing routes when the resource index must be refreshed without running the complete database preparation task. It writes database records and does not remove records for routes that no longer exist. The task itself does not synchronize LesliShield privileges; `lesli:db:prepare` performs that optional follow-up when LesliShield is loaded.

---

## Diagnostics & Status

### Show Lesli Status

```shell
bin/rails lesli:status
```

**Purpose:** Prints the configured instance name, current Rails environment, and the name, code, path, version, and build information reported for installed Lesli engines and gems.

The task accepts no arguments or options and only reads framework registration and configuration data. Use it to verify which components the application loaded and whether they came from the expected installation.

### Show the Development Welcome

```shell
bin/rails lesli:dev:welcome
```

**Purpose:** Prints additional blank lines and then invokes `lesli:status`.

Despite the `dev` namespace, the implementation does not enforce a development-only environment. It is a read-only convenience command; use `lesli:status` directly in scripts and diagnostics that do not need the extra formatting.

---

## Generators

### Supported Context

`lesli:install` is the host-application generator. The resource generators below are development tools for a Rails engine repository whose `bin/rails` defines `ENGINE_ROOT`, as a generated Rails engine does. They derive the Ruby namespace and destination paths from that engine root.

Do not run the resource generators from a conventional host Rails application: a standard application does not define `ENGINE_ROOT`, and the generators cannot determine their destination.

Each resource generator requires `NAME` and accepts zero or more Rails-style attributes:

```text
NAME [field:type field:type]
```

Singular and plural names are normalized. For example, `tickets` generates a singular `Ticket` model and service plus a plural `TicketsController` and views directory.

The resource generators expose the same Rails runtime options listed for `lesli:install`. Because generated files are starting points, use `--pretend` first and review every generated file before committing it.

### Model

```shell
bin/rails generate lesli:model tickets
```

Creates `app/models/<engine_name>/ticket.rb` with the engine namespace, its `ApplicationRecord` base, and a `belongs_to :account` association. It does not create a migration. Although the shared generator signature accepts attributes, the model template does not add columns or validations from them.

### Controller

```shell
bin/rails generate lesli:controller tickets subject:string description:text
```

Creates `app/controllers/<engine_name>/tickets_controller.rb` with Lesli-style CRUD actions and service integration. Attribute names are added to the generated strong-parameter allowlist. Review authorization, response handling, messages, and route helpers before using the controller in an application.

### Service

```shell
bin/rails generate lesli:service tickets
```

Creates `app/services/<engine_name>/ticket_service.rb` with account-scoped `find`, `index`, `create`, `show`, `update`, and `destroy` methods. The accepted attribute list does not change the service template.

### Views

```shell
bin/rails generate lesli:views tickets subject:string description:text owner_id:integer
```

Creates these files under `app/views/<engine_name>/tickets/`:

```text
_form.html.erb
index.html.erb
new.html.erb
show.html.erb
```

Regular attributes become generic form controls, `description` becomes a textarea, and names ending in `_id` become selects with empty option collections that the application must populate. The generated views depend on LesliView components and require product-specific table columns, associations, labels, authorization, and empty or error states.

### Scaffold

```shell
bin/rails generate lesli:scaffold tickets
```

The scaffold invokes the model, controller, service, and views generators, then invokes Rails' Active Record migration and resource-route generators. It can therefore create multiple Ruby and ERB files, a migration, and a `resources :tickets` route.

The Rails help output advertises `field:type` attributes for this generator. In the current Rails 8.1 implementation, however, parsed attribute objects are forwarded directly to the child generators and fail before generation completes. Until that forwarding is corrected, do not use the attribute form of `lesli:scaffold`; invoke the specialized generators and Rails migration and route generators separately.

Use `--pretend` to inspect the complete scaffold operation before allowing it to write files:

```shell
bin/rails generate lesli:scaffold tickets --pretend
```
