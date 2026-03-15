# Rails Credentials

Lesli uses **Rails Credentials** to manage sensitive configuration values securely across environments.

This includes secrets such as database credentials, API keys, service tokens, and integration settings required by Lesli modules and third-party providers.

By storing this information in encrypted credentials files, you can keep sensitive values out of your source code while still making them available to your application at runtime.

---

## Editing Rails Credentials

To edit credentials for a specific environment, run one of the following commands.

### Ubuntu / Linux Desktop

```shell
EDITOR="code --wait" rails credentials:edit --environment development
EDITOR="code --wait" rails credentials:edit --environment production
EDITOR="code --wait" rails credentials:edit --environment test
EDITOR="code --wait" rails credentials:edit
```

### macOS / Ubuntu Server

```shell
EDITOR="nano" rails credentials:edit --environment development
EDITOR="nano" rails credentials:edit --environment production
EDITOR="nano" rails credentials:edit --environment test
EDITOR="nano" rails credentials:edit
```

These commands open the encrypted credentials file in your selected editor.

---

## Recommended Credentials Structure

Some Lesli modules require credentials for internal services or third-party integrations such as AWS, Google, Firebase, and Honeybadger.

The following structure is recommended for organizing credentials in a Lesli-based application:

```yaml
# Identify the current Lesli installation
implementation: "lesli-localhost"

# Database credentials
db:
  database: ""
  username: ""
  password: ""
  host: ""
  port: ""

# Internal Lesli services
services:
  jwt:
    secret: "your-secret-json-web-token-key"

# Third-party providers
providers:
  aws_s3:
    region: eu-central-1
    bucket: ""
    access_key_id: ""
    secret_access_key: ""

  aws_ses:
    region: eu-central-1
    access_key_id: ""
    secret_access_key: ""

  aws_sns:
    region: eu-central-1
    access_key_id: ""
    secret_access_key: ""

  google:
    client_id: ""
    client_secret: ""
    maps_sdk_token: ""
    tag_manager: ""

  firebase:
    api_key: ""
    admin_sdk_private_key: ""
    web: ""

  honey_badger:
    api_key: ""
    personal_token: ""

# Rails secret key base
secret_key_base: "your-secret-key-base"
```

This structure is only a recommendation. You may organize credentials differently depending on your application and which Lesli modules you use.

---

## Overriding Credentials with Environment Variables

Most credentials can also be overridden with environment variables. This is useful when deploying to staging or production, working with Docker, or configuring CI/CD pipelines.

### Naming Convention

Use the following format:

```text
LESLI_<SECTION>_<GROUP>_<KEY>
```

Where:

* `LESLI` is the fixed prefix
* `SECTION` is the top-level namespace in your credentials file
* `GROUP` is the integration or category inside that section
* `KEY` is the specific credential field

### Example

If your credentials file contains:

```yaml
providers:
  honey_badger:
    api_key: "my-api-key"
```

You can override it with:

```shell
LESLI_PROVIDERS_HONEY_BADGER_API_KEY="my-super-secret-api-key"
```

### Why Use Environment Variables?

* Configure secrets differently per environment
* Keep sensitive values out of the repository
* Simplify cloud and container-based deployments
* Integrate cleanly with CI/CD workflows

---

## Database Configuration

Open your database configuration file:

```text
config/database.yml
```

Lesli currently supports **PostgreSQL** and **SQLite**.

The following example shows a PostgreSQL configuration using values stored in Rails Credentials:

```yaml
default: &default
  adapter: postgresql
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000

development:
  <<: *default
  database: <%= Rails.application.credentials.dig(:db, :database) %>
  username: <%= Rails.application.credentials.dig(:db, :username) %>
  password: <%= Rails.application.credentials.dig(:db, :password) %>

test:
  <<: *default
  database: <%= Rails.application.credentials.dig(:db, :database) %>
  username: <%= Rails.application.credentials.dig(:db, :username) %>
  password: <%= Rails.application.credentials.dig(:db, :password) %>

production:
  <<: *default
  host: <%= Rails.application.credentials.dig(:db, :host) %>
  port: <%= Rails.application.credentials.dig(:db, :port) %>
  database: <%= Rails.application.credentials.dig(:db, :database) %>
  username: <%= Rails.application.credentials.dig(:db, :username) %>
  password: <%= Rails.application.credentials.dig(:db, :password) %>
```

This approach keeps database connection details encrypted and centralized inside Rails Credentials.
