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

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.dev
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

# · Tools used to extend Rails functionality
require "kaminari"


# · Tools used to build the Lesli Framework
require "L2"
require "devise"
require "useragent"


module Lesli
    class Engine < ::Rails::Engine
        isolate_namespace Lesli

        initializer :lesli do |app|

            # Lesli Framework configuration


            # Include lib/assets folder in the asset pipeline
            config.assets.paths << root.join("lib", "assets")

            config.assets.paths << root.join("lib", "sass")

            # Include third-party assets
            config.assets.paths << root.join("vendor")

            # Default languages
            config.i18n.default_locale = :en
            config.i18n.available_locales = [:en]

            # Force to not use digest, 
            # if this is not false Rails will fingerprint the assets by default and precompile is needed
            config.assets.digest = false

            config.action_mailer.preview_path = root.join("lib", "mailer_previews")


            # Lesli standard engine configuration

            
            # register assets manifest
            config.assets.precompile += %w[lesli_manifest.js]

            # register engine migrations path
            unless app.root.to_s.match root.to_s
                config.paths["db/migrate"].expanded.each do |expanded_path|
                    app.config.paths["db/migrate"] << expanded_path
                end
            end
        end
    end
end
