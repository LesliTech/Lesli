# Lesli Initializer

This guide explains the configuration options available in the `config/initializers/lesli.rb` file. Customize the core behavior, UI, security, and internationalization of your Lesli-based application.


### Generate Lesli initializer

```shell
rails g lesli:install
```

Lesli includes the base lesli configuration, so you can only edit the parts required for your specific needs.

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
        tagline: "The Open SaaS Development Platform."
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


    # Customize system-wide security behavior.
    config.security = {
        # Default password for development, test & demo environments
        password: "Test123!",       
        enable_debug: false,
        enable_becoming: false,
        enable_analytics: true,
        enable_login_otp: true,
        enable_login_link: true,
        allow_multiaccount: true,
        allow_registration: true
    }


    # Customize the color palette and layout.
    config.theme = {
        color_primary: "#193d8d",
        color_sidebar: "#ffffff",
        color_header: "transparent",
        color_footer: "transparent",
        color_background: "#eef2f6",
        color_sidebar_hover: "#dee7ec"
    }


    #
    config.layout = {
        tasks: true,
        babel: false,
        profile: true,
        notifications: true
    }


    # Specify default paths for email templates.
    config.mailer = {
        templates: "lesli_mailer/emails/lesli"
    }

    # Control redirection paths after login.
    config.path_after_login = "/"
    config.path_after_login = "/dashboard" if defined?(LesliDashboard)
end
```

#### You can modify just parts of the defaults as you need:

```ruby
Lesli.configure do |config|
    config.demo = true
    config.security[:allow_multiaccount] = false
end
```


### Tips

> NOTE: Some settings can also be overridden using ENV variables.
> Use the format: `LESLI_<SECTION>_<KEY>`
> Example: `LESLI_SECURITY_ENABLE_DEBUG=false`
