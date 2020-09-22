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

        config.lesli_settings = Lesli::settings(Rails.env)

        # Settings in config/environments/* take precedence over those specified here.
        config.i18n.default_locale = config.lesli_settings["env"]["default_locale"]
        config.i18n.available_locales = config.lesli_settings["configuration"]["locales"]
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

        # Haml is deprecated, but we still have it until we change all files to erb
        config.generators do |g|
            g.template_engine :erb
        end

    end

end

Rails.application.configure do

    begin
        raise "Error with database credentials" if not Rails.application.credentials.config.has_key?(:db)
        raise "Error with database credentials" if not Rails.application.credentials.db.has_key?(:database)
        raise "Error with database credentials" if not Rails.application.credentials.db.has_key?(:username)
        raise "Error with database credentials" if not Rails.application.credentials.db.has_key?(:password)

        raise "Error with service credentials" if not Rails.application.credentials.config.has_key?(:services)

        raise "Error with service aws credentials" if not Rails.application.credentials.services.has_key?(:aws)
        raise "Error with service aws credentials" if not Rails.application.credentials.services[:aws].has_key?(:access_key_id)
        raise "Error with service aws credentials" if not Rails.application.credentials.services[:aws].has_key?(:secret_access_key)
        raise "Error with service aws credentials" if not Rails.application.credentials.services[:aws].has_key?(:region)
        raise "Error with service aws credentials" if not Rails.application.credentials.services[:aws].has_key?(:bucket)

        raise "Error with service smtp credentials" if not Rails.application.credentials.services.has_key?(:smtp)
        raise "Error with service smtp credentials" if not Rails.application.credentials.services[:smtp].has_key?(:port)
        raise "Error with service smtp credentials" if not Rails.application.credentials.services[:smtp].has_key?(:address)
        raise "Error with service smtp credentials" if not Rails.application.credentials.services[:smtp].has_key?(:user_name)
        raise "Error with service smtp credentials" if not Rails.application.credentials.services[:smtp].has_key?(:password)
        raise "Error with service smtp credentials" if not Rails.application.credentials.services[:smtp].has_key?(:delivery_method)
    rescue StandardError => e 
        puts ""; puts ""; puts ""; 
        puts "=  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   ="
        puts "=  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   ="
        puts "";
        puts "Rails credentials error: " + e.message
        puts "";
        puts "=  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   ="
        puts "=  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   ="
    end

    puts ""; puts ""; puts "";
    puts "Loading installed engines: "
    puts "=  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   =  *   ="
    Lesli::engines.each do |engine|
    puts "- #{engine["name"]}"
    end
    puts ""; puts "";

end
