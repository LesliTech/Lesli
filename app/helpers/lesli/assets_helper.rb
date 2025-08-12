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

module Lesli
    module AssetsHelper
        # Return a string path to load the template stylesheet
        # by default we always return the latest version of the template
        #
        # stylesheet from main App
        # lesli_asset_path()               
        # /assets/application.css
        #
        # Specific stylesheet from Engine
        # lesli_asset_path(:lesli, 'application') 
        # /assets/lesli/application.css
        #
        # Specific stylesheet from gem
        # lesli_asset_path(:lesli_assets, 'templates/application')
        # /assets/lesli_assets/templates/application.css
        def lesli_asset_path(engine = nil, stylesheet = 'application')

            # Stylesheets from specific engine
            return "#{engine}/#{stylesheet}" if engine.present?

            # Get current engine information
            engine_code = lesli_engine(:code)

            # Rails main host app stylesheets
            return 'application' if engine_code == 'root'

            # Rails engines stylesheets
            "#{engine_code}/#{stylesheet}"
        end

        def favicon
            icon_path = customization_instance_logo_url(logo: "favicon")

            safe_join([
                tag.link(href: icon_path, rel: "alternate icon"),
                tag.link(href: icon_path, rel: "icon", type: "image/svg+xml"),
                tag.link(href: icon_path, rel: "mask-icon", color: "#ff8a01")
            ])
        end
    end
end
