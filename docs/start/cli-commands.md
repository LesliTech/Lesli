# CLI Commands

Lesli Core adds Rails generators and Rake tasks to the host application. Run the commands in this reference from the relevant application or engine root and prefer `bin/rails` so the project's locked Rails and gem versions are used.

Commands under `lesli:` are provided by Lesli Core. Commands such as `server`, `db:migrate`, and `credentials:edit` are standard Rails commands and are outside this reference.

---

## Overview

| Command | Purpose | Changes files or data? |
| ------- | ------- | ---------------------- |
| `bin/rails generate lesli:install` | Mounts Lesli and creates its initializer | Yes: routes and initializer |
| `bin/rails generate lesli NAME [field:type ...]` | Generates a complete engine resource | Yes: resource files, routes, and Account association |
| `bin/rails lesli:install:migrations` | Copies Lesli Core migrations into the host application | Yes: migration files |
| `bin/rails lesli:db:prepare` | Prepares the database and configures installed Lesli modules | Yes: schema and records |
| `bin/rails lesli:db:build` | Prepares, seeds, and configures the database without dropping it | Yes: schema and application data |
| `bin/rails lesli:db:seed` | Loads seeds and configures installed Lesli modules | Yes: application data |
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

The task does not load seed data, including when Rails creates a new database. Lesli preserves the standard Rails database preparation flow while temporarily disabling Rails' automatic seed loader. Run it after installing Lesli, adding an engine, or deploying schema and route changes. It has no production guard and writes schema and application records, so review migrations and use the application's normal deployment safeguards.

### Build the Database

```shell
bin/rails lesli:db:build
```

**Purpose:** Prepares a complete Lesli database without dropping existing data.

It performs these operations:

1. Invokes the same schema preparation used by `lesli:db:prepare`.
2. Loads seeds from installed Lesli engines and the host application.
3. Builds the resource index and initializes accounts and installed engines.
4. Synchronizes LesliShield privileges and LesliBabel translations when those engines are loaded.
5. Prints `lesli:status`.

Use this command to initialize a new environment or update an existing database when both migrations and seed data must be applied. Unlike `lesli:db:rebuild`, it does not drop the database and is not restricted to development or test.

The command is non-destructive at the database level, but its seeders can still create or update application records. Review every active seed file and use the application's normal backup and deployment safeguards before running it against persistent production data.

### Load Seed Data

```shell
bin/rails lesli:db:seed
```

**Purpose:** Loads seed files for each installed Lesli engine, invokes the host application's Rails `db:seed` task, and configures Lesli accounts and installed modules.

After loading seeds, the task rebuilds the resource index, initializes every Lesli account and its installed engines, synchronizes LesliShield privileges when available, and scans and imports LesliBabel translations when available. This ensures accounts created by seeders are ready to use.

**Side effects:** Creates or updates seed and configuration records, then prints `lesli:status`. There is no production restriction. Review every active seed file before running this command against persistent data; Core seed output may include initial user credentials.

See [Database Tasks and Seeders](/engines/lesli/database/seeders/) for seed order, idempotency, and production guidance.

### Rebuild the Database

```shell
bin/rails lesli:db:rebuild
```

> **Warning:** This command permanently deletes the current database data. Use it only with a disposable development or test database.

**Purpose:** Recreates a complete Lesli database from migrations and seeds.

It performs these operations:

1. Invokes Rails `db:migrate:reset` to drop and recreate the database.
2. Runs the migrations currently available from the host and installed engines.
3. Regenerates the host application's configured schema file.
4. Loads Lesli engine and host-application seeds.
5. Builds resources and initializes accounts and installed engines.
6. Prints the status report.

The task does not manually delete versioned schema files. Rails regenerates `db/schema.rb` or `db/structure.sql` from the migrations that remain available. Therefore, removing an engine also removes its tables from the rebuilt schema when its migrations are supplied only by that engine. Migrations previously copied into the host application's `db/migrate` directory remain available and will still run.

The task runs only in the Rails development and test environments. It raises an error in staging, production, and custom environments. This guard cannot detect a development or test configuration connected to the wrong database, so verify the active database before running it.

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

### Generate a Complete Resource

Run the generator from the engine that will own the resource:

```shell
bin/rails generate lesli ticket subject:string description:text
```

The command creates the complete Lesli resource structure:

* An account-scoped model and versioned migration.
* A CRUD service and controller.
* An operator for non-CRUD domain operations.
* Index, show, new, edit, and form views.
* English locale entries.
* Model, service, operator, and controller tests.
* A `has_many` association on the engine's local `Account` model.
* A REST resource entry in the engine routes.

The generator derives the namespace, paths, local account table, and migration prefix from the current engine. It requires the engine to have an `Account` model, a routes file, and a versioned account migration. Singular and plural resource names are normalized, so `ticket` and `tickets` both generate a `Ticket` model and `TicketsController`.

Use `--pretend` before writing files:

```shell
bin/rails generate lesli ticket subject:string description:text --pretend
```

Remove the generated structure with the matching Rails destroy command:

```shell
bin/rails destroy lesli ticket
```

Review generated files before committing them. The generator establishes the Lesli conventions and CRUD baseline, but product-specific validations, authorization rules, operator methods, and interface details still belong to the engine.

#### Attributes

Attributes use the standard Rails generator syntax:

```shell
bin/rails generate lesli ticket \
    subject:string \
    description:text \
    owner:references \
    due_at:datetime
```

Reference attributes create an optional model association, a database reference, and the corresponding `<name>_id` strong parameter. Active Storage attachment attributes and rich-text attributes use the Rails generator attribute types supported by the installed Rails version.

#### Options

| Option | Behavior |
| ------ | -------- |
| `--skip-operator` | Does not create the operator or its test |
| `--skip-views` | Generates an API-oriented resource without HTML views |
| `--skip-tests` | Does not create generated tests |
| `--items=activities attachments discussions tasks` | Enables selected Lesli Item concerns and view components |
| `--migration-namespace=NN` | Uses the requested two-digit feature namespace instead of allocating the next available one |
| `--engine-root=PATH` | Targets an engine other than the current engine |
| `--engine-namespace=NAME` | Overrides the Ruby namespace derived from the target directory |

The `--items` values are optional and must be selected explicitly. Attachments require the host application to have the Active Storage tables and storage service configured; see [Items](/engines/lesli/backend/items/).

`lesli:resource` and `lesli:scaffold` are aliases for the same complete generator. Prefer the shorter public command:

```shell
bin/rails generate lesli ticket
```

### Specialized Generators

Lesli also keeps the lower-level `lesli:model`, `lesli:controller`, `lesli:service`, and `lesli:views` generators for focused maintenance work. They create only their named layer and do not provide the complete resource contract, migration, routes, Account association, operator, locales, or full test set. Prefer the complete generator for new resources.
