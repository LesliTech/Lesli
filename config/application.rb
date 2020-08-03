=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

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

        config.time_zone = "UTC"

        config.lesli_settings = Lesli::settings

        # Settings in config/environments/* take precedence over those specified here.
        config.i18n.default_locale = config.lesli_settings["env"]["i18n_default_locale"]
        config.i18n.available_locales = [:en, :de, :es]
        config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
        config.i18n.load_path += Dir[Rails.root.join("engines", "*", "config", "locales", "**", "*.{rb,yml}")]
        config.autoload_paths += Dir[Rails.root.join("config", "routes")]
        config.autoload_paths += Dir[Rails.root.join("lib")]

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

    end

end
