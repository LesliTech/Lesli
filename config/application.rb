require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LesliCloud
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Load another routes directory
    config.autoload_paths += %W(#{config.root}/config/routes)

    config.i18n.load_path += Dir[
        Rails.root.join('config', 'locales', '**', '*.{rb,yml}'), 
        Rails.root.join('config', 'locales', '**', '**', '*.{rb,yml}')
    ]
    config.i18n.available_locales = [:en, :es]
    config.i18n.default_locale = :en

    config.time_zone = 'Central America'

    # SES SMTP Settings
    config.action_mailer.smtp_settings = {
        user_name: 'AKIA6P562IZOMLG57DKK',
        password: 'BP9pXKeyCH3gznFRLDKJ3uvYR2n1Cn4Dy6e+lmQXoOnA',
        address: 'email-smtp.eu-west-1.amazonaws.com',
        authentication: :plain,
        port: '587'
    }

  end
end
