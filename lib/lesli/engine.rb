=begin

Lesli

Copyright (c) 2025, Lesli Technologies, S. A.

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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

# · Tools used to extend Rails functionality
require "kaminari"


# · Tools used to build the Lesli Framework
require "L2"
#require "useragent"
require "acts_as_paranoid"

# The hole Lesli ecosystem depends on current_user, so we
# include the dependency in the core
require "devise"

require "lesli_date"
require "lesli_view"
require "lesli_assets"
require "lesli_system"

require "importmap-rails"
require "turbo-rails"

module Lesli
    class Engine < ::Rails::Engine
        isolate_namespace Lesli

        initializer "lesli.importmap", before: "importmap" do |app|
            app.config.importmap.paths << Engine.root.join("config/importmap.rb")
        end

        initializer :lesli do |app|


            # Lesli standard engine configuration

            
            # register assets manifest
            config.assets.precompile += %w[lesli_manifest.js]

            # register engine migrations path
            unless app.root.to_s.match root.to_s
                config.paths["db/migrate"].expanded.each do |expanded_path|
                    app.config.paths["db/migrate"] << expanded_path
                end
            end


            # Lesli Framework configuration


            # Default languages
            config.i18n.default_locale = :en
            config.i18n.available_locales = [:en]

            # Force to not use digest, 
            # if this is not false Rails will fingerprint the assets by default 
            # and precompile will be needed, so, donot digest if not production
            config.assets.digest = false unless Rails.env.production?


            # Lesli Framework Mailer configuration


            # Add the Lesli root folder for email development tempaltes
            config.action_mailer.preview_paths << root.join("lib", "mailer_previews")


            # Does not work too well
            # if Lesli.config.security.dig(:enable_debug)
            #     config.cache_classes = false
            #     config.eager_load = false
            #     config.consider_all_requests_local = true
            #     config.action_controller.perform_caching = false
            # end
        end
    end
end
