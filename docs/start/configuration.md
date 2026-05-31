# Lesli Initializer

This guide explains the configuration options available in `config/initializers/lesli.rb`.

Use this file to customize the core behavior of your Lesli-based application, including system identity, localization, date and time formats, security settings, theme options, layout features, and mailer paths.

---

## Generate the Initializer

If you have not already generated the Lesli initializer, run:

```shell
rails generate lesli:install
```

This command creates the base Lesli configuration file:

```text
config/initializers/lesli.rb
```

Lesli provides sensible defaults, so in most cases you only need to change the settings relevant to your application.

---

## Full Configuration Example

```ruby
Lesli.configure do |config|

# Enable or disable demo mode.
config.demo = false


# Installation identifier
config.instance = "Lesli"


# Provides organization details displayed throughout the system.
config.company = {
    name: "Lesli",
    email: "hello@lesli.tech",
    tagline: "The Open-Source SaaS Development Framework for Ruby on Rails."
}


# List of supported languages (requires `LesliBabel`).
config.locales = {
    :en => "English",       # English
    :de => "Deutsch",       # Deutsch/German
    :pl => "Polski",        # Polski/Polish/Poland
    :nl => "Dutch",         # Dutch/Nederlands/Netherlands
    :es => "Español",       # Español/Spanish
    :uk => "украї́нська",    # украї́нська/Ukrainian
    :sr => "Српски",        # Српски/Srpski/Serbian
    :it => "Italiano",      # Italiano/Italian
    :hr => "Hrvatski",      # Hrvatski/Croatian
    :fr => "Français",      # French
    :pt => "Português",     # Portuguese
    :tr => "Türkçe",        # Turkish
    :ro => "Română",        # Romanian
    :bg => "български"      # Bulgarian
}


# Define time zone, week start day, and custom date/time formats.
config.datetime = {
    :time_zone => "America/Guatemala",
    :start_week_on => "monday",
    :formats => {
        :date => "%d/%m/%Y",
        :time => "%H:%M",
        :date_time => "%d/%m/%Y %H:%M",
        :date_words => "%A, %B %d, %Y",
        :date_time_words => "%A, %B %d, %Y, %H:%M", 
        :date_time_words_pm => "%A, %B %d, %Y, %I:%M %p", 
        :date_time_words_day => "%A, %B %d, %Y, %H:%M", 
    }
}


# Customize the color palette and layout.
config.theme = {
    color_primary: "#245F93",
    color_sidebar: "#ffffff",
    color_header: "transparent",
    color_footer: "transparent",
    color_background: "#eef2f6",
    color_sidebar_hover: "#E3EEF6"
}


#
config.layout = {
    tasks: true,
    profile: true,
    notifications: true
}


# Customize system-wide security behavior.
config.security = {
    # Default password for non-production environments
    password: "Test123!", 
    enable_debug: false,
    enable_becoming: false,
    enable_login_otp: true,
    enable_login_link: true,
    allow_multiaccount: true,
    allow_registration: true
}

# Shield module configuration
config.shield = {
    login_title: "Welcome to Lesli",
    path_after_login: defined?(LesliDashboard) ? "/dashboard" : "/"
}


# Audit module configuration
config.audit = {
    prefix: 'LA',
    enable_logs: true,
    enable_journals: true,
    enable_analytics: true
}


# Mailer module configuration
config.mailer = {
    templates: "lesli_assets/emails"
}


# Support module configuration
config.support = {
    prefix: 'LS'
}
end
```

---

## Common Configuration Areas

### Demo Mode

Use `config.demo` to enable or disable demo-specific behavior.

```ruby
config.demo = false
```

### Instance and Company Information

Use `config.instance` and `config.company` to define how your application is identified across the platform.

```ruby
config.instance = "Lesli"
config.company = {
  name: "Lesli",
  email: "hello@lesli.tech",
  tagline: "The Open SaaS Development Platform."
}
```

### Localization

Use `config.locales` to define the languages available in your application. This requires **LesliBabel**.

### Date and Time

Use `config.datetime` to control the application time zone, the first day of the week, and the date and time formats used across the interface.

### Security

Use `config.security` to define system-wide security behavior, including registration, login options, development passwords, and debugging features.

### Theme

Use `config.theme` to customize the visual appearance of the platform.

### Layout

Use `config.layout` to enable or disable selected layout features such as notifications, profile access, task shortcuts, or translation tools.

### Mailer

Use `config.mailer` to define the default path for email templates.

### Redirect After Login

Use `config.path_after_login` to control the default destination after authentication.

---

## Overriding Only What You Need

You do not need to redefine the full configuration file. You can override only the values relevant to your application.

```ruby
Lesli.configure do |config|
  config.demo = true
  config.security[:allow_multiaccount] = false
end
```

This keeps your initializer smaller and easier to maintain.

---

## Environment Variable Overrides

Some settings can also be overridden with environment variables.

Use the following format:

```text
LESLI_<SECTION>_<KEY>
```

Example:

```text
LESLI_SECURITY_ENABLE_DEBUG=false
```

This is useful for deployment environments where configuration should not be stored directly in source code.
