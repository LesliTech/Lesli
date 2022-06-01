require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.hosts << "051c-200-114-115-138.ngrok.io"

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true
end



# Override configuration for environment
# every rails upgrade needs to add different configuration, so we should only override the specific config
# instead of changing the original object due on the next release rails is going to reset to default values
Rails.application.configure do

    # Raise an Error When an Asset is Not Found
    config.assets.unknown_asset_fallback = false

    # Force to not use digest, if this is not false Rails will fingerprint the assets by default and precompile is needed
    config.assets.digest = false

    # Enable/disable caching. By default caching is disabled.
    # Run rails dev:cache to toggle caching.
    if Rails.root.join('tmp', 'caching-dev.txt').exist?
        config.cache_store = :file_store, "#{root}/tmp/file_store_cache/"
    end

    # Mailer configuration
    config.action_mailer.preview_path = "#{Rails.root}/lib/mailer_previews"

    config.action_mailer.raise_delivery_errors = true

    config.action_mailer.perform_deliveries = true

    config.action_mailer.delivery_method = Rails.configuration.lesli_settings["env"]["action_mailer"]["delivery_method"].to_sym

    # add configuration for SMTP using mailgun 
    if config.action_mailer.delivery_method == :smtp
        config.action_mailer.smtp_settings = {
            authentication: :plain,
            port: Rails.application.credentials.providers[:mailgun][:smtp][:port],
            address: Rails.application.credentials.providers[:mailgun][:smtp][:server],
            password: Rails.application.credentials.providers[:mailgun][:smtp][:password],
            user_name: Rails.application.credentials.providers[:mailgun][:smtp][:username]
        }
    end

    config.action_mailer.asset_host = Rails.configuration.lesli_settings["env"]["action_mailer"]["asset_host"]
    
    config.action_mailer.default_url_options = { 
        host: Rails.configuration.lesli_settings["env"]["action_mailer"]["default_url_options_host"] 
    }

    config.action_mailer.default_options = {

        # this option is also customized in app/mailers/application_lesli_mailer.rb
        from: Rails.configuration.lesli_settings["env"]["action_mailer"]["default_options_from"]
    }

end
