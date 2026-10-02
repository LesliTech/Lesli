# Database Tasks and Seeders

Lesli separates schema preparation, framework configuration, and seed data. This distinction matters in production: migrations and account initialization may be required for a deployment, while sample data usually is not.

---

## Task Reference

Run database tasks through the host Rails application:

| Command | Behavior |
| --- | --- |
| `bin/rails lesli:db:prepare` | Runs Rails `db:prepare`, configures Lesli for every account, and prints system status |
| `bin/rails lesli:db:seed` | Loads seed files for installed Lesli engines, then the host application's seeds, and prints status |
| `bin/rails lesli:db:rebuild` | Drops and recreates the database, seeds it, configures accounts, and prints status |
| `bin/rails db:migrate:status` | Shows the migration state assembled from the host and installed engines |

`lesli:db:prepare` does not load seed data. This makes it suitable for applying schema changes and initializing installed engines without creating demo records.

```shell
bin/rails lesli:db:prepare
```

The configuration phase also:

* Rebuilds the controller and action resource index from Rails routes
* Initializes core and installed-engine records for existing accounts
* Builds privileges when LesliShield is installed
* Scans and imports translations when LesliBabel is installed

### Destructive rebuild

`lesli:db:rebuild` permanently deletes the current database data and removes `db/schema.rb` before rebuilding it.

```shell
bin/rails lesli:db:rebuild
```

The task refuses to drop the database in production. Use it only for a disposable development environment and verify the active Rails environment before running it.

---

## Seed Loading Order

`lesli:db:seed` performs these steps:

1. Reads installed engines from `LesliSystem.engines`.
2. Calls `Engine.load_seed` for each installed Lesli engine, excluding the host application's `Root` entry.
3. Invokes the host application's standard `db:seed` task.
4. Prints Lesli system status.

Lesli Core is an engine and loads its own `db/seeds.rb` through the same process. Its seed files create the initial account and users from `Lesli.config.company` and `Lesli.config.security`.

The final set of seed files depends on which engine constants are loaded. Installing an engine does not guarantee useful seed data; its `db/seeds.rb` decides what to create for the active environment.

---

## Organize Engine Seeds

Use `db/seeds.rb` as the engine entrypoint and keep focused seed logic under `db/seed`:

```text
my_engine/
└── db/
    ├── seeds.rb
    └── seed/
        ├── defaults.rb
        ├── development.rb
        └── production.rb
```

Load stable records unconditionally and gate sample data by environment or demo mode:

```ruby
Termline.info(
  "Loading seeds for: MyEngine #{MyEngine::VERSION} (#{MyEngine::BUILD})"
)

load MyEngine::Engine.root.join("db", "seed", "defaults.rb")

if Rails.env.development? || Lesli.config.demo
  load MyEngine::Engine.root.join("db", "seed", "development.rb")
end
```

Use `load` for seed fragments because seed tasks may run more than once in the same process and the file should execute each time.

Do not load development fixtures in production merely because the file exists. `Lesli.config.demo` should be enabled only for disposable evaluation environments.

---

## Make Seeds Idempotent

Seed tasks must be safe to run repeatedly. Find records by a stable natural key and update or create the desired state:

```ruby
account = Lesli::Account.find_by!(email: Lesli.config.company.fetch(:email))

engine_account = MyEngine::Account.find_or_initialize_by(account: account)
engine_account.name = account.name
engine_account.status = :active
engine_account.save!
```

For a fixed lookup record:

```ruby
priority = MyEngine::CatalogItem.find_or_initialize_by(
  catalog: priority_catalog,
  key: "normal"
)

priority.name = "Normal"
priority.default = true
priority.save!
```

Avoid unconditional `create!` calls for records that have stable identities; a second seed run would either duplicate the data or fail a unique index.

Wrap a group in a transaction when partial creation would leave unusable state:

```ruby
MyEngine::ApplicationRecord.transaction do
  # Create or update related seed records.
end
```

---

## Configuration and Production Safety

Core seeds depend on application configuration, including:

```ruby
Lesli.configure do |config|
  config.company = config.company.merge(
    name: "Acme",
    email: "owner@example.com"
  )

  config.security = config.security.merge(
    password: ENV.fetch("LESLI_SEED_PASSWORD", nil)
  )
end
```

Validate required configuration before seeding. Never commit production passwords, API tokens, or customer data to seed files.

Treat seed command output as sensitive. The core seed workflow reports initial user credentials, and production behavior can differ when LesliShield and demo mode are configured.

Seed files are application code: review them before running `lesli:db:seed` against an existing production database and back up data before any high-risk operation.

---

## What Belongs in Seeds

Good seed candidates include:

* Required lookup values and default catalogs
* Initial roles or engine configuration records
* A development-only sample dataset
* Records needed to make a newly installed engine usable

Do not use seeds for:

* Schema changes, indexes, or constraints
* One-time production data corrections
* Large fixtures used only by automated tests
* Secrets or environment-specific credentials committed to source control

Schema changes belong in migrations. One-time operational data changes should use an explicit, reviewed task or deployment procedure. Test fixtures and factories belong with the test suite.

---

## Verify a Seeder

For a disposable development or test database:

```shell
bin/rails lesli:db:seed
bin/rails lesli:db:seed
```

The second run should succeed without changing record counts unexpectedly. Also test the environments or demo-mode branches the engine supports.

After installing a new engine, run `lesli:db:prepare` before its seeds so its migrations and per-account initialization are complete.
