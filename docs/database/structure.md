# Database Architecture

By default, Lesli Core and every installed Rails engine share the host application's database. Each package owns its migrations and tables, while Rails combines their migration paths into one ordered migration set at runtime.

This gives the application one transactional data layer without moving engine schema definitions into the host application.

```text
Host Rails database
├── Lesli Core tables
├── LesliAdmin tables
├── LesliShield tables
├── LesliSupport tables
├── Other installed engine tables
└── Host application tables
```

An engine adds its expanded `db/migrate` path to the host application during initialization. Rails discovers migrations recursively, including version folders such as `db/migrate/v1` and `db/migrate/v1.0`. Copying engine migrations into the host application is not part of the standard Lesli workflow.

---

## Core Tables

Lesli Core currently owns four tables:

| Table | Code | Responsibility |
| --- | --- | --- |
| `lesli_accounts` | `00.00.00.01` | Top-level account identity and lifecycle |
| `lesli_users` | `00.00.00.02` | User identity, authentication fields, and account membership |
| `lesli_roles` | `00.00.00.03` | Account-scoped role definitions |
| `lesli_resources` | `00.00.00.04` | Hierarchical controller, action, and route registry |

The core tables provide the shared identities that optional engines reference. Engine-specific settings, profile details, privileges, audit records, notifications, and other domain data remain in the engine that implements them.

### Main relationships

```text
lesli_accounts
├── has many lesli_users
├── has many lesli_roles
└── has one account record in participating engines

lesli_resources
└── belongs to an optional parent lesli_resource
```

`lesli_accounts.user_id` can identify the account owner, while `lesli_users.account_id` associates each user with an account. Roles also belong to an account. LesliShield extends users and roles with authorization tables rather than placing those records in Lesli Core.

---

## Engine Table Ownership

Prefix engine-owned tables with the engine's snake-case name:

```text
lesli_admin_accounts
lesli_shield_user_roles
lesli_support_tickets
lesli_calendar_events
```

The prefix prevents collisions and makes ownership visible in the shared schema. A model and migration should live in the package that owns the business concept.

Most business records are account-scoped. Choose the foreign key deliberately:

* Reference `lesli_accounts` when the record belongs directly to the core account.
* Reference `<engine>_accounts` when it depends on engine-specific account state.
* Reference `lesli_users` for the user who owns, creates, or receives the record.
* Use an explicit `to_table` whenever the Rails association name does not match the table name.

```ruby
add_reference(
  :lesli_support_tickets,
  :account,
  null: false,
  foreign_key: { to_table: :lesli_support_accounts }
)

add_reference(
  :lesli_support_tickets,
  :owner,
  foreign_key: { to_table: :lesli_users }
)
```

Add indexes for the queries and uniqueness rules the application actually uses. For account-scoped identifiers, enforce uniqueness with the account key:

```ruby
add_index(
  :lesli_support_tickets,
  [:account_id, :uid],
  unique: true
)
```

---

## Shared Migration Structures

Lesli includes migration helpers for schema repeated across engines. They are mixed into `ActiveRecord::Migration` by the Lesli initializer.

| Helper | Creates |
| --- | --- |
| `create_table_lesli_shared_account_10(engine)` | The engine's account table and its reference to `lesli_accounts` |
| `create_table_lesli_shared_catalogs_10(engine)` | Engine catalog and catalog-item tables |
| `create_table_lesli_item_tasks_10(engine)` | Account-scoped polymorphic tasks |
| `create_table_lesli_item_activities_10(engine)` | Account-scoped polymorphic activities |
| `create_table_lesli_item_discussions_10(engine)` | Account-scoped polymorphic discussions |
| `create_table_lesli_item_attachments_10(resource)` | Attachments for a specific resource table |
| `create_table_lesli_item_subscribers_10(resource)` | Subscribers for a specific resource table |
| `create_table_lesli_item_versions_10(resource)` | Field-change history for a specific resource table |

For example, an engine can create its shared account record and item tables without reproducing their columns:

```ruby
class CreateLesliSupportAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table_lesli_shared_account_10(:lesli_support)
    create_table_lesli_item_tasks_10(:lesli_support)
    create_table_lesli_item_activities_10(:lesli_support)
    create_table_lesli_item_discussions_10(:lesli_support)
  end
end
```

Use a shared helper only when its complete schema and behavior fit the feature. A domain table with different lifecycle or ownership requirements should use a normal Rails migration.

---

## Models and Soft Deletion

`Lesli::ApplicationLesliRecord` enables `acts_as_paranoid`. Tables used by models that inherit from it need an indexed `deleted_at` column:

```ruby
t.datetime :deleted_at, index: true
```

Do not add soft deletion automatically to every join or event table. Use it only when recovery, auditability, or business rules require records to remain in the database after deletion.

See [Models](/engines/lesli/backend/models) for framework model conventions and account scoping.

---

## Schema Sources of Truth

Use these sources for different questions:

| Source | Use |
| --- | --- |
| Package migrations | History and executable schema changes |
| Host `db/schema.rb` | Current schema produced by the installed package set |
| Package models | Associations, validations, and application behavior |
| `docs/database.md`, when present | Compact registry of stable table codes |

The host schema varies with the installed engines. Do not treat the dummy application's schema as the complete schema of every Lesli installation.

When a package keeps a table-code registry, update it in the same change as the migration. The migration files remain the executable source of truth.
