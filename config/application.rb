=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require_relative "boot"

require "rails/all"

require "./lesli"

# Require the gems listed in Gemfile, including any gems
# you"ve limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Lesli
    
    class Application < Rails::Application

        # Initialize configuration defaults for originally generated Rails version.
        config.load_defaults 6.0

        config.lesli_settings = Lesli::settings(Rails.env)

        # Settings in config/environments/* take precedence over those specified here.
        config.i18n.default_locale = config.lesli_settings["env"]["default_locale"]
        config.i18n.available_locales = config.lesli_settings["configuration"]["locales"]
        config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
        config.i18n.load_path += Dir[Rails.root.join("engines", "*", "config", "locales", "**", "*.{rb,yml}")]
        config.autoload_paths += Dir[Rails.root.join("config", "routes")]
        config.autoload_paths += Dir[Rails.root.join("lib")]

        # Default time zone for the app, this can change if necessary
        config.time_zone = "UTC"

        # Default time zone for database - DO NOT CHANGE -
        config.active_record.default_timezone = :utc

        # Catch errors (enabled on environments/production.rb)
        config.exceptions_app = self.routes # dev

        # for i18n-js
        config.middleware.use I18n::JS::Middleware

        config.middleware.insert_before 0, Rack::Cors do
            allow do
                origins "*"
                resource "/api/*",
                headers: :any,
                expose: %w(access-token expiry token-type uid client),
                methods: %i(get post options put)
            end
        end

        # Haml is deprecated, but we still have it until we change all files to erb
        config.generators do |g|
            g.template_engine :erb
        end

    end

end
