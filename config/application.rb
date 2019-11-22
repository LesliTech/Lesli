require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LesliCloud

    class Application < Rails::Application

        # Initialize configuration defaults for originally generated Rails version.
        config.load_defaults 6.0

        # Settings in config/environments/* take precedence over those specified here.
        # Application configuration can go into files in config/initializers
        # -- all .rb files in that directory are automatically loaded after loading
        # the framework and any gems in your application.
        config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
        config.i18n.load_path += Dir[Rails.root.join('engines', '*', 'config', 'locales', '**', '*.{rb,yml}')]
        config.autoload_paths += Dir[Rails.root.join('config', 'routes')]
        config.i18n.default_locale = :en
        config.i18n.available_locales = [:en]

        # for i18n-js
        config.middleware.use I18n::JS::Middleware

        config.autoload_paths << Rails.root.join('lib')

    end

end
