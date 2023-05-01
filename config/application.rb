=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

require "./lesli"

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module Lesli
    class Application < Rails::Application

        # Initialize configuration defaults for originally generated Rails version.
        config.load_defaults 7.0

        # Lesli configuration 
        config.lesli = Lesli::settings(Rails.env).deep_symbolize_keys

        # Settings in config/environments/* take precedence over those specified here.
        config.i18n.default_locale = config.lesli.dig(:env, :default_locale)
        config.i18n.available_locales = config.lesli.dig(:configuration, :locales)
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

        config.middleware.insert_before 0, Rack::Cors do
            allow do
                origins "*"
                resource "/api/*",
                    headers: :any,
                    expose: %w(access-token expiry token-type uid client),
                    methods: %i(get post options put)
                resource "/ws/*",
                    headers: :any,
                    expose: %w(access-token expiry token-type uid client),
                    methods: %i(get post options put)
            end
        end

        config.generators.system_tests = nil
        config.generators do |g|
            g.helper false
            g.template_engine :erb
            g.test_framework(
                :rspec,
                fixtures: false, 
                view_specs: false, 
                model_specs: false,
                helper_specs: false,
                routing_specs: false,
                controller_specs: false
            )
        end

        # workaround for the sassc/engine.rb:43: [BUG] Segmentation fault
        config.assets.configure do |env|
            env.export_concurrent = false
        end

    end
end
