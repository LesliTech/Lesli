=begin

Lesli

Copyright (c) 2025, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

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
            :date_time_words => "%A, %B %d, %Y, %H:%M",         # 24 hours datetime in words format (default)
            :date_time_words_pm => "%A, %B %d, %Y, %I:%M %p",   # 12 hours datetime in words format
            :date_time_words_day => "%A, %B %d, %Y, %H:%M",     # 24 hours datetime in words format (default)
        }
    }


    # Customize system-wide security behavior.
    config.security = {
        password: "Test123!",       # Default password for development, test & demo environments
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
