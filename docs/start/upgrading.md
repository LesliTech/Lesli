# Upgrade Guide

This guide covers the coordinated Lesli release based on Ruby 3.3.5, Rails
8.1, the Tailwind-only frontend, and the final first version of Record Items.
Read the changelog in every installed package before updating its lockfile.

## Target Versions

| Package | Version |
| --- | --- |
| Lesli | 5.1.13 |
| LesliAdmin | 1.1.2 |
| LesliAudit | 1.1.2 |
| LesliBabel | 1.1.3 |
| LesliBell | 1.1.2 |
| LesliCalendar | 1.1.2 |
| LesliDashboard | 1.1.3 |
| LesliShield | 1.1.7 |
| LesliSupport | 1.2.3 |
| LesliAssets | 1.1.6 |
| LesliDate | 1.1.0 |
| LesliSystem | 1.1.0 |
| LesliTesting | 1.4.2 |
| LesliView | 1.1.6 |
| Termline | 1.1.3 |

## 1. Upgrade the Runtime

Use Ruby 3.3.5 and Rails 8.1 for the application and CI environment. Lesli
gems accept Ruby 3.3 releases, but 3.3.5 is the tested release baseline.

Update the bundle and confirm that the host does not retain an older Rails
line:

```shell
bundle update rails lesli
bundle exec rails --version
ruby --version
```

Update optional engines together because their account and Item contracts are
coordinated with Lesli 5.1.

## 2. Adopt the Tailwind Entrypoint

Tailwind is now the official styling system. Engine source entrypoints are
named `source/tailwind/application.css`, and compiled assets are written to
`app/assets/stylesheets/<package>/application.css`.

Remove host imports, build tasks, and dependencies that exist only for the old
Sass/Bulma pipeline. Rename any local `application.tailwind.css` entrypoint to
`application.css`, update its build destination, and rebuild assets:

```shell
make build.tailwind
```

Do not edit compiled engine stylesheets directly.

## 3. Prepare Active Storage for Attachments

Applications that use Item Attachments must provide Rails Active Storage. If
the host does not already have its migration, install it once:

```shell
bin/rails active_storage:install
bin/rails db:migrate
```

Do not create one copy per engine. The shared tables are
`active_storage_blobs`, `active_storage_attachments`, and
`active_storage_variant_records`.

For AWS S3 or Cloudflare R2, add the adapter to the host application and
configure the service in `config/storage.yml`:

```shell
bundle add aws-sdk-s3
```

See [Record Items](/engines/lesli/backend/items/) and the
[LesliSupport provider examples](/engines/support/tickets/attachments/).

## 4. Update Item Integrations

Replace legacy Item writes with the parent-resource APIs:

```ruby
ticket.record_activity!(
  actor: current_user,
  code: :ticket_updated,
  metadata: { from: previous_values, to: current_values }
)

ticket.add_task!(
  creator: current_user,
  title: "Follow up with customer"
)

ticket.add_comment!(
  author: current_user,
  message: "Customer confirmed the change"
)
```

`activities_create` is no longer the supported API. Discussions are plain
text and linear; code that stores HTML, replies, or threads must be migrated to
another domain model. Task completion is reversible and uses the shared update
endpoint.

Every concrete Item model must declare its table and its local engine account.
The parent resource must return that account through `lesli_item_account`.
Engine controllers must use explicit resource allowlists; do not resolve a
class directly from a request parameter.

## 5. Reconcile Existing Databases

The first Item implementation was not released for production, so its original
engine migrations were corrected in place instead of adding compatibility
migrations. An application that already ran those pre-release migrations will
not receive the new columns, constraints, foreign keys, or indexes by running
`db:migrate` alone.

For disposable development/test databases, rebuild after updating:

```shell
bin/rails lesli:db:rebuild
```

This command destroys local data. Never use it for a database that must be
preserved.

For a persistent database, write an application migration that brings the
existing schema to the released contract before deploying. In particular,
verify:

* Every engine account has one Core account and the expected unique index.
* Item `account_id` foreign keys point to the owning engine's account table.
* Task and discussion ownership columns are non-null and obsolete
  `deleted_at` columns have been removed.
* Activity codes and JSON metadata are present and existing rows satisfy the
  final validations.
* Attachment tables exist and Active Storage tables are installed in the host.

Back up persistent data and rehearse this migration against a copy before the
production deployment.

## 6. Authentication and Seeds

Lesli Core can initialize and seed without LesliShield. Applications that need
Devise authentication, password changes, roles, and privileges should install
LesliShield. Re-run the seed task only when the installed engine's release
notes require it:

```shell
bin/rails lesli:db:seed
```

## 7. Verify the Upgrade

```shell
bundle exec rails zeitwerk:check
bundle exec brakeman
bin/rails lesli:status
bin/rails test
bin/rails test:system
```

When the host supports PostgreSQL in production, repeat its integration suite
against PostgreSQL rather than relying only on SQLite.
