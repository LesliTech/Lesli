require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Lesli
    
    class Application < Rails::Application

        config.defaults = config_for(:defaults)
        
        # Initialize configuration defaults for originally generated Rails version.
        config.load_defaults 6.0

        config.time_zone = "UTC"

        # Settings in config/environments/* take precedence over those specified here.
        config.i18n.default_locale = Rails.configuration.defaults["i18n_default_locale"]
        config.i18n.available_locales = Rails.configuration.defaults["i18n_available_locales"]
        config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
        config.i18n.load_path += Dir[Rails.root.join('engines', '*', 'config', 'locales', '**', '*.{rb,yml}')]
        config.autoload_paths += Dir[Rails.root.join('config', 'routes')]
        
        config.autoload_paths += Dir[Rails.root.join('lib')]

        # for i18n-js
        config.middleware.use I18n::JS::Middleware

    end

end
