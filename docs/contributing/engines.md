# Engine Documentation Standard

Every Lesli engine owns the documentation for its installation, integration points, data, and public behavior. Keep that source in the engine repository under `docs`; the Lesli website copies it into the generated documentation site.

This standard defines the shared structure. It does not require every engine to publish empty pages for features it does not implement.

---

## Documentation Structure

Use the engine README as its public landing page. It should explain the engine's purpose, primary capabilities, quick start, development setup, and support links without duplicating the detailed guides.

Organize integration documentation under `docs/about` and domain guides in separate folders:

```text
docs/
├── navigation
├── about/
│   ├── installation.md
│   ├── configuration.md
│   ├── translations.md
│   ├── dashboards.md
│   ├── database.md
│   └── tasks.md
├── feature-name/
│   ├── index
│   └── workflow.md
└── images/
```

Only `installation.md` is required for every engine. Add the other pages when the engine exposes the corresponding integration:

| Page | Include when |
| --- | --- |
| `installation.md` | Always |
| `configuration.md` | The engine adds configuration keys, credentials, environment variables, or initializers |
| `translations.md` | The engine renders user-facing text or supplies locale files |
| `dashboards.md` | The engine registers components with LesliDashboard |
| `database.md` | The engine owns migrations or persistent tables |
| `tasks.md` | The engine exposes supported Rake tasks for users or operators |

Do not publish an empty page, generated placeholder, or commented task scaffold. Omit the file until the integration exists.

Use a meaningful domain folder for product documentation such as `tickets`, `accounts`, or `notifications`. Give the folder an `index` file for its landing page; do not use `readme.md` as a nested documentation route.

---

## Navigation

The `docs/navigation` file controls the engine sidebar. Keep the common pages together and put domain sections after them:

```erb
<%= navigation_for_folder(
  "engines",
  "my-engine",
  "about",
  order: ["installation", "configuration", "translations", "dashboards", "database", "tasks"]
) %>
<%= navigation_for_folder("engines", "my-engine", "tickets") %>
```

The generator ignores missing files, so the shared order works for engines without configuration, dashboards, or tasks.

Keep existing public URLs stable when reorganizing published documentation. If a page must move, add a website redirect before removing the old route.

---

## Installation Page

An installation guide must allow a developer to reach a working engine without consulting its source code. Include:

1. Supported Lesli and Rails versions
2. The gem installation command
3. Standard and manual route mounting
4. Database preparation
5. Optional engine integrations
6. A route, page, or command that verifies the installation
7. Upgrade instructions when they differ from installation

Use the Lesli router as the default:

```ruby
Rails.application.routes.draw do
  Lesli::Router.mount(self)
end
```

Show direct mounting only as an alternative for applications that do not use the standard router:

```ruby
Rails.application.routes.draw do
  mount MyEngine::Engine => "/my-engine"
end
```

Prepare the host application through the Lesli task so migrations and installed-engine initialization both run:

```shell
bin/rails lesli:db:prepare
```

Do not use the unscoped `rake` executable in application instructions. `bin/rails` selects the host application's environment and dependency set.

---

## Translation Page

An engine owns its labels under its snake-case engine code. Store one file per supported locale:

```text
config/locales/translations.en.yml
config/locales/translations.es.yml
```

Use exactly one engine namespace followed by a feature or controller bucket and a label:

```yaml
en:
  my_engine:
    tickets:
      title: "Tickets"
      create: "Create ticket"
```

Reference the full path in Ruby or ERB:

```erb
<%= I18n.t("my_engine.tickets.title") %>
```

The structure has these responsibilities:

| Level | Example | Responsibility |
| --- | --- | --- |
| Locale | `en` | Rails locale |
| Engine | `my_engine` | Prevents collisions with the host and other engines |
| Bucket | `tickets` | Groups one controller, feature, or shared concern |
| Label | `title` | Identifies one translatable value |

Use `shared` only for labels reused inside that engine. Framework-wide labels belong to Lesli Core, not to every engine.

Document interpolation and pluralization where the engine uses them. Do not construct translated sentences by concatenating fragments.

When LesliBabel is installed, `bin/rails lesli:db:prepare` scans engine routes and imports local translation files. During focused development the same operations can be run directly:

```shell
bin/rails lesli_babel:scan
bin/rails lesli_babel:import
```

Locale files remain the version-controlled source shipped with the gem. Review generated translation changes before committing them.

---

## Dashboard Page

Document dashboard integration only when the engine defines a dashboard model and components. Register component names in a model inherited from `Lesli::Shared::Dashboard`:

```ruby
module MyEngine
  class Dashboard < Lesli::Shared::Dashboard
    COMPONENTS = [
      :summary,
      { activity: { size: 8, position: 2, config: { limit: 10 } } }
    ].freeze
  end
end
```

A symbol uses the LesliDashboard defaults. A hash can provide initial `size`, `position`, and `config` values.

For each component, add a partial to the engine dashboard view directory:

```text
app/views/my_engine/dashboards/_component-summary.html.erb
app/views/my_engine/dashboards/_component-activity.html.erb
```

The shared renderer resolves `activity` as `component-activity` and passes the persisted component as the `component` local. The page should explain:

* The component's purpose and data source
* Its registered name and partial path
* Supported configuration values
* Its default grid size and position
* Empty, loading, and error behavior
* Any authorization or account-scoping requirements

Register missing dashboards and components for existing accounts with:

```shell
bin/rails lesli_dashboard:register
```

Registration creates missing records but does not replace an existing user's persisted component settings.

---

## Database Page

The database page is a compact ownership and migration registry, not a replacement for migrations or `db/schema.rb`.

Start with the engine's collection and engine codes, then list every owned table:

| Migration code | Table | Responsibility | Important relationships |
| --- | --- | --- | --- |
| `07.02.11.01.10` | `lesli_support_tickets` | Support requests | Account, owner, status |

Use the full ten-digit migration version, including its revision. Explain:

* Which tables reference `lesli_accounts` and which reference the engine account
* Shared migration helpers used to create structures
* Important foreign keys and unique indexes
* Soft-deletion behavior
* Optional cross-engine dependencies
* Commands used to prepare and verify the schema

Link to [Database Architecture](/engines/lesli/database/structure) and [Migration Versioning](/engines/lesli/database/versioning) instead of duplicating those shared rules.

---

## Task Page

Create `tasks.md` only for executable, supported tasks. For each task document:

| Field | Meaning |
| --- | --- |
| Command | Complete `bin/rails namespace:task` invocation |
| Purpose | Result produced by the task |
| Environment | Development-only, deployment, or safe in all environments |
| Inputs | Arguments, environment variables, files, or records read |
| Side effects | Data, files, cache, or external services changed |
| Repeatability | Whether rerunning it is idempotent |

Put destructive warnings immediately before the command. Do not document commented examples, internal helper methods, or tasks that still reference retired namespaces.

---

## Feature Guides

The common `about` pages explain how the engine integrates with Lesli. Product behavior belongs in domain guides.

A feature landing page should cover:

* What the feature does and who can use it
* Its main workflow and entry route
* Important states, permissions, and account boundaries
* Extension points intended for host applications
* Related configuration, data, and tasks

Document supported behavior, not unfinished scaffold routes or models that are not exposed by the engine.

---

## Review Checklist

Before publishing engine documentation:

* Verify every command against the current repository tasks.
* Verify gem names, Ruby constants, route prefixes, and translation namespaces.
* Compare the database table registry with `db/migrate`.
* Confirm dashboard component names have matching partials.
* Remove documentation for integrations the engine does not implement.
* Replace VitePress or other retired-site components with standard Markdown and ERB supported by `lesli.dev`.
* Check image paths and meaningful alternative text.
* Build the generated documentation site and open every new route.
* Keep examples specific enough that copying them produces a valid result.

When behavior changes, update the owning engine's documentation in the same pull request. Do not edit the generated website copy directly.
