# Internationalization

Rails.application.configure do

    config.i18n.available_locales = [:en, :es, :de, :fr]

    config.i18n.default_locale = :en

    config.i18n.fallbacks = true

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml')].sort

    config.i18n.load_path += Dir[Rails.root.join('engines', 'CloudLesli', 'config', 'locales', '**', '*.yml')].sort

end
