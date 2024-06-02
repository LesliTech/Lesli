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
require "ancestry"
require "useragent"
require "acts_as_paranoid"

module Lesli
    class Engine < ::Rails::Engine
        isolate_namespace Lesli

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


            # Development mailer by default
            config.action_mailer.delivery_method ||= :letter_opener

            # Add the Lesli root folder for email development tempaltes
            config.action_mailer.preview_path = root.join("lib", "mailer_previews")

            config.action_mailer.default_options ||= {

                # Use the main email in the lesli settings as email sender
                from: config.company.dig(:email)
            }

            # Mailer url options for development 
            config.action_mailer.default_url_options ||= { 
                host: "http://0.0.0.0:3000"
            }
        end
    end
end
