# Lesli Configuration

Lesli applications override framework settings in `config/initializers/lesli.rb`. The Lesli gem provides the default values, and the installation generator creates a small application initializer for settings that differ in the host application.

Keep secrets out of this file. Store passwords, tokens, and provider keys in [Rails credentials](/engines/lesli/start/credentials/) or in environment variables read explicitly by your application.

---

## Generate the Initializer

Run the installation generator if the application does not already have a Lesli initializer:

```shell
bin/rails generate lesli:install
```

The generator creates `config/initializers/lesli.rb` with a minimal configuration block:

```ruby
Lesli.configure do |config|
  config.demo = false
end
```

You only need to add settings that your application overrides.

---

## Configuration Areas

| Setting | Purpose | Provider |
| ------- | ------- | -------- |
| `demo` | Enables demo-specific seed and interface behavior | Lesli Core |
| `instance` and `company` | Identifies the installation and organization | Lesli Core |
| `datetime` | Defines the time zone, week start, and display formats | Lesli Core and LesliDate |
| `theme` and `layout` | Defines shared visual and layout preferences | Lesli Core and presentation packages |
| `security` | Defines registration, account, and development-password behavior | Lesli Core and LesliShield |
| `babel` | Defines available application locales | LesliBabel |
| `shield` | Defines the post-login path and default role | LesliShield |
| `audit` | Enables audit logs, journals, and analytics | LesliAudit |
| `mailer` | Defines the shared email-template path | Lesli Core |
| `support` | Defines support ticket settings | LesliSupport |

Settings for optional engines have an effect only when the corresponding engine is installed.

---

## Core Identity

Use `config.instance` and `config.company` to identify the installation. Company information is also used when Lesli seeds the initial account.

```ruby
Lesli.configure do |config|
  config.instance = "Acme Cloud"
  config.company = config.company.merge(
    name: "Acme",
    email: "hello@example.com",
    tagline: "Tools for distributed teams"
  )
end
```

Set `config.demo` to `true` only for disposable evaluation environments. Demo mode exposes predefined sign-in details and changes seed behavior.

---

## Date and Time

Use `config.datetime` for the application time zone, first day of the week, and shared date formats:

```ruby
Lesli.configure do |config|
  config.datetime = config.datetime.merge(
    time_zone: "America/Guatemala",
    start_week_on: "monday",
    formats: config.datetime.fetch(:formats).merge(
      date: "%d/%m/%Y",
      time: "%H:%M",
      date_time: "%d/%m/%Y %H:%M"
    )
  )
end
```

Format values use Ruby `strftime` directives.

---

## Localization

LesliBabel reads supported languages from `config.babel[:locales]`. The first locale becomes the Rails default locale when LesliBabel initializes.

```ruby
Lesli.configure do |config|
  config.babel = config.babel.merge(
    locales: {
      en: "English",
      es: "Español"
    }
  )
end
```

This setting requires LesliBabel. There is no top-level `config.locales` setting.

---

## Security and Authentication

The core `security` settings control the development password and the registration behavior used by LesliShield:

```ruby
Lesli.configure do |config|
  config.security = config.security.merge(
    password: "DevelopmentOnly123!",
    allow_multiaccount: false,
    allow_registration: false
  )
end
```

The configured password is used by seed and demo workflows. Do not use a shared development password in production.

LesliShield-specific settings belong under `config.shield`:

```ruby
Lesli.configure do |config|
  config.shield = config.shield.merge(
    path_after_login: "/dashboard",
    default_role: "guest"
  )
end
```

Use `config.shield[:path_after_login]`; `config.path_after_login` is not a supported setting.

---

## Theme and Layout

Use the shared theme and layout hashes to override only the values your installed presentation packages consume:

```ruby
Lesli.configure do |config|
  config.theme = config.theme.merge(
    color_primary: "#245F93",
    color_background: "#EEF2F6"
  )

  config.layout = config.layout.merge(
    tasks: true,
    profile: true,
    notifications: true
  )
end
```

---

## Optional Engine Settings

Configure optional engines in their matching namespace:

```ruby
Lesli.configure do |config|
  config.audit = config.audit.merge(
    enable_logs: true,
    enable_journals: true,
    enable_analytics: true
  )

  config.support = config.support.merge(prefix: "LS")
  config.mailer = config.mailer.merge(templates: "lesli_assets/emails")
end
```

Refer to each engine's documentation before changing engine-specific keys.

---

## Preserve Default Hash Values

Assigning a new hash replaces the entire existing setting. Use `merge` when you only want to override selected keys:

```ruby
Lesli.configure do |config|
  config.security = config.security.merge(allow_registration: false)
end
```

This preserves other defaults supplied by the framework.

---

## Environment Variables

Lesli does not automatically translate variables named `LESLI_<SECTION>_<KEY>` into configuration values. Read environment variables explicitly in the initializer when an application needs deployment-specific behavior:

```ruby
Lesli.configure do |config|
  boolean = ActiveModel::Type::Boolean.new

  config.demo = boolean.cast(ENV.fetch("LESLI_DEMO", config.demo))

  if ENV.key?("LESLI_ALLOW_REGISTRATION")
    config.security = config.security.merge(
      allow_registration: boolean.cast(ENV["LESLI_ALLOW_REGISTRATION"])
    )
  end
end
```

Use Rails credentials or a deployment secret manager for sensitive values rather than committing them to the initializer.
