# Rails Credentials

Use Rails encrypted credentials for secrets that the application or an installed Lesli module needs at runtime. Typical examples include provider keys, service tokens, and production database credentials.

Do not put secrets in `config/initializers/lesli.rb` or commit unencrypted secret files to the repository.

---

## Edit Credentials

Edit the shared credentials file with your preferred editor:

```shell
EDITOR="code --wait" bin/rails credentials:edit
```

For an environment-specific file, include the environment name:

```shell
EDITOR="code --wait" bin/rails credentials:edit --environment development
EDITOR="code --wait" bin/rails credentials:edit --environment test
EDITOR="code --wait" bin/rails credentials:edit --environment production
```

For a terminal editor, replace `code --wait` with a command such as `nano`:

```shell
EDITOR="nano" bin/rails credentials:edit --environment production
```

Rails stores shared credentials in `config/credentials.yml.enc`. Environment-specific commands create files under `config/credentials/` with matching key files. An environment-specific credentials file replaces the shared file for that environment; Rails does not merge the two files.

Keep production decryption keys outside source control and provide them through the deployment platform, commonly with `RAILS_MASTER_KEY`.

---

## Suggested Structure

Only define entries required by the application and its installed modules. The following example includes values read by the current Lesli core interface and a reusable PostgreSQL section:

```yaml
db:
  host: "localhost"
  port: 5432
  username: "lesli"
  password: "replace-me"
  databases:
    development: "lesli_development"
    test: "lesli_test"
    production: "lesli_production"

providers:
  apple:
    app_id: ""

  google:
    tag_manager: ""

  honey_badger:
    api_key: ""

secret_key_base: "replace-with-a-generated-secret"
```

Generate secret values instead of copying the placeholders. Rails can generate a suitable random value with:

```shell
bin/rails secret
```

Provider settings are optional. Omit integrations the application does not use.

---

## Environment Variables

Lesli does not automatically convert variables named `LESLI_<SECTION>_<GROUP>_<KEY>` into Rails credentials. Applications must read environment variables explicitly where they are consumed.

For example, `config/database.yml` can prefer an environment variable and fall back to encrypted credentials:

```yaml
password: <%= ENV.fetch("DB_PASSWORD") { Rails.application.credentials.dig(:db, :password) } %>
```

Rails also supports the standard `DATABASE_URL` environment variable for database deployments. Use the configuration mechanism required by the hosting platform, and avoid duplicating the same secret across multiple stores.

---

## PostgreSQL Configuration

New Rails applications use SQLite by default and do not need database credentials for local development. For PostgreSQL, add the `pg` gem and configure `config/database.yml` with distinct database names for development, test, and production:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS", 5) %>
  host: <%= ENV.fetch("DB_HOST") { Rails.application.credentials.dig(:db, :host) } %>
  port: <%= ENV.fetch("DB_PORT") { Rails.application.credentials.dig(:db, :port) } %>
  username: <%= ENV.fetch("DB_USERNAME") { Rails.application.credentials.dig(:db, :username) } %>
  password: <%= ENV.fetch("DB_PASSWORD") { Rails.application.credentials.dig(:db, :password) } %>

development:
  <<: *default
  database: <%= Rails.application.credentials.dig(:db, :databases, :development) %>

test:
  <<: *default
  database: <%= Rails.application.credentials.dig(:db, :databases, :test) %>

production:
  <<: *default
  database: <%= Rails.application.credentials.dig(:db, :databases, :production) %>
```

Add the PostgreSQL adapter if it is not already present:

```shell
bundle add pg
```

Never point the test environment at the development or production database.

---

## Operational Guidance

* Commit encrypted `.yml.enc` files only when the team intends to share them.
* Never commit `config/master.key` or files under `config/credentials/*.key`.
* Use different credentials and encryption keys for development, test, staging, and production.
* Rotate a credential immediately if its plaintext value appears in source control, logs, screenshots, or support messages.
* Restart application processes after changing credentials so the new values are loaded.
