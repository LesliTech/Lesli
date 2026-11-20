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
| `leslibabel` | Defines available application locales | LesliBabel |
| `leslishield` | Defines the post-login path and default role | LesliShield |
| `lesliaudit` | Controls audit writes and data-retention periods | LesliAudit |
| `leslimailer` | Defines the shared email-template path | Lesli Core |
| `leslisupport` | Defines support ticket settings | LesliSupport |

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

### Timezone policy

Store timestamps representing instants in UTC. Core applies the authenticated
user's `time_zone` profile preference during each request. When unset, it uses
`config.datetime[:time_zone]`, then the Rails application timezone.

LesliDate, Date2, Calendar forms, Agenda and FullCalendar use this active zone.
An explicit LesliDate `zone:` argument still takes precedence. Login does not
capture the browser timezone; there is no timezone cookie, session setting or
reload-based detection. Users change their preference in their profile.
Jobs and mailers must explicitly apply the recipient's zone with
`Time.use_zone(user.effective_time_zone)` because they do not run inside this
HTTP callback. See [Jobs and emails](/gems/date/about/configuration#jobs-and-emails)
for examples, including queued delivery.

Changing the display zone does not change stored instants. Calendar dates such
as birthdays remain `date` values rather than UTC timestamps.

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

### Registration terms

Legal acceptance is optional and disabled by default. The host can enable it
without replacing LesliShield's registration form:

```ruby
Lesli.configure do |config|
    config.shield.merge!(
        require_terms_acceptance: true,
        terms_url: "/terms",
        terms_version: "2026-11-20.1",
        privacy_url: "/privacy",
        privacy_version: "2026-11-20.1"
    )
end
```

The host owns the publicly accessible pages and supplies both URLs and versions.
Shield displays an unchecked required checkbox, validates acceptance on the
server, and records `terms_accepted_at`, `terms_version` and `privacy_version`.
Forms with outdated versions require review and confirmation again. Recording
the privacy notice version does not authorize advertising or unrelated uses.

This applies only to public signup. Existing users, seeders, administrative
creation and invitations retain their current behavior. Disabling the setting
hides the notice and records no acceptance. It does not disable registration.
The optional configuration has no effect when LesliShield is absent.

New Core databases include the nullable columns. Existing databases need those
columns added before enabling acceptance; editing the original migration does
not update a database that already ran it. Hosts retain responsibility for
document versions, eligibility wording and any future reacceptance policy.

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
    enable_analytics: true,
    analytics_retention_days: 400,
    traffic_retention_days: 400,
    audit_retention_days: nil
  )

  config.support = config.support.merge(prefix: "LS")
  config.mailer = config.mailer.merge(templates: "lesli_assets/emails")
end
```

Refer to each engine's documentation before changing engine-specific keys.
Audit retention values are positive integers measured in days. Authenticated
application usage uses `analytics_retention_days`, imported provider traffic
uses `traffic_retention_days`, and activity events use
`audit_retention_days`. A `nil` value disables cleanup for that data class;
activity events default to `nil` so the host must opt into their deletion
explicitly.

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
