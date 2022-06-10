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

        # deprecated, will be deleted at January, 2022
        config.lesli_settings = Lesli::settings(Rails.env) 

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

        # for i18n-js
        config.middleware.use I18n::JS::Middleware

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
