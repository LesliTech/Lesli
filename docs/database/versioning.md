# Migration Versioning

Rails normally prefixes migration files with timestamps. Lesli packages replace that timestamp with a stable ten-digit code so migrations from many engines remain unique, ordered, and attributable to their owner.

```text
CC EE NN TT VV
│  │  │  │  └─ Migration version
│  │  │  └──── Table number
│  │  └─────── Feature namespace
│  └────────── Engine number
└───────────── Collection number
```

Each segment contains exactly two decimal digits.

| Segment | Meaning | Example |
| --- | --- | --- |
| `CC` | Business collection shared by related engines | `07` for IT and help desk |
| `EE` | Engine within the collection | `02` for LesliSupport |
| `NN` | Feature namespace within the engine | `11` for tickets |
| `TT` | Stable table number inside the namespace | `01` for the tickets table |
| `VV` | Migration revision for that table or structure | `10` for version 1.0 |

The [Lesli Ecosystem](/engines/lesli/about/ecosystem) is the source for collection and engine codes. Allocate namespace and table numbers inside the owning engine without reusing an existing code.

---

## Read a Migration Name

Consider the LesliSupport migration:

```text
0702110110_create_lesli_support_tickets.rb
```

Its formatted code is `07.02.11.01.10`:

| Digits | Meaning |
| --- | --- |
| `07` | IT and help-desk collection |
| `02` | LesliSupport engine |
| `11` | Tickets namespace |
| `01` | Tickets table |
| `10` | First migration revision, version 1.0 |

Lesli Core reserves collection and engine code `00.00`. Its accounts migration is therefore:

```text
0000000110_create_lesli_accounts.rb
```

---

## Migration Revisions

Keep `CC`, `EE`, `NN`, and `TT` stable for the lifetime of a table. Advance only `VV` when a later migration changes that table.

| Schema release | Migration prefix | Purpose |
| --- | --- | --- |
| 1.0 | `0702110110` | Create `lesli_support_tickets` |
| 1.1 | `0702110111` | Add a ticket column or index |
| 1.2 | `0702110112` | Apply another compatible change |
| 2.0 | `0702110120` | Apply the table's version 2.0 change |

The two-digit `VV` value identifies the migration revision; Rails still stores the complete ten-digit prefix in `schema_migrations` and decides whether it has run.

Every migration version must be globally unique across the complete application. Before choosing a prefix, search all local packages:

```shell
find engines gems -path "*/db/migrate/*" -type f | sort
```

---

## Directory Layout

Keep versioned migrations below the package's `db/migrate` directory:

```text
my_engine/
└── db/
    └── migrate/
        ├── v1/
        │   ├── 0702110110_create_lesli_support_tickets.rb
        │   └── 0702110111_add_importance_to_lesli_support_tickets.rb
        └── v2/
            └── 0702110120_change_lesli_support_ticket_importance.rb
```

Use `v1`, `v2`, and so on for new packages. Some existing engines use folders such as `v1.0`; Rails discovers both forms recursively, so do not rename a published migration solely to normalize its folder.

The folder organizes a package release. The filename prefix remains the identifier Rails records.

---

## Create a Migration

Generate the migration with Rails or the Lesli scaffold, then assign its Lesli prefix before running it:

```shell
bin/rails generate migration CreateLesliSupportTickets
```

Move the generated file into the current version folder and replace its timestamp:

```text
20261002143000_create_lesli_support_tickets.rb
    ↓
db/migrate/v1/0702110110_create_lesli_support_tickets.rb
```

Use `create_<table>` for the first migration. For later changes, name the operation precisely:

```text
0702110111_add_importance_to_lesli_support_tickets.rb
0702110112_add_account_uid_index_to_lesli_support_tickets.rb
0702110120_change_lesli_support_ticket_importance.rb
```

Preserve the migration API version generated for the supported Rails version:

```ruby
class AddImportanceToLesliSupportTickets < ActiveRecord::Migration[8.1]
  def change
    add_column :lesli_support_tickets, :importance, :string
  end
end
```

Use `up` and `down` when Rails cannot infer a safe reversal.

---

## Never Rewrite Published History

Do not rename, renumber, move, or edit a migration after it has been released or applied in a shared environment. Rails tracks the numeric prefix, so changing it can make an existing migration appear new and run it twice.

Some existing packages still contain timestamp-prefixed legacy migrations. Leave published legacy files unchanged and use the ten-digit Lesli format for new migrations.

If a released schema needs correction:

1. Keep the original migration unchanged.
2. Create a new migration with the same table code and the next available `VV` value.
3. Make the new change reversible when practical.
4. Test migration from the previous released schema and from an empty database.

Only renumber a generated timestamp before the migration has been shared or executed outside your disposable local database.

---

## Dependency Order

Migration order must satisfy foreign keys:

1. Lesli Core identity tables
2. An engine's account and shared lookup tables
3. Domain tables that reference those identities
4. Join, item, and history tables that reference domain records

The numeric prefix controls global ordering, not the folder name. A migration in `v2` with a lower numeric prefix will still sort before a higher-prefix migration in `v1`.

Avoid depending on an optional engine unless that dependency is declared by the gem. A migration that references `lesli_shield_*` cannot run in an installation where LesliShield is absent.

---

## Verify Migrations

Run migrations through the host Rails application, because it assembles the paths for all installed engines:

```shell
bin/rails db:migrate
bin/rails db:migrate:status
```

For a new migration, verify both directions when it is reversible:

```shell
bin/rails db:migrate
bin/rails db:rollback STEP=1
bin/rails db:migrate
```

Then prepare a clean test database and run the relevant test suite:

```shell
RAILS_ENV=test bin/rails db:prepare
bin/rails test
```

Review the generated `db/schema.rb` as part of the change. It should contain only the intended tables, columns, indexes, and foreign keys.

---

## Migration Checklist

* Confirm the collection and engine codes in the ecosystem registry.
* Confirm the namespace and table code are unused in the package.
* Confirm the full ten-digit migration version is globally unique.
* Rename a generated timestamp before running or sharing the migration.
* Use the owning engine's table prefix.
* Add explicit foreign keys and query-driven indexes.
* Keep account scoping and soft-deletion behavior consistent with the model.
* Add a new migration instead of editing released history.
* Verify migrate, rollback when supported, clean database setup, and tests.
* Update the package's table-code registry when it maintains one.
