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
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    module AssetsHelper
        # Return a string path to load the template stylesheet
        # by default we always return the latest version of the template
        # lesli_application_stylesheet_path()               -> stylesheet from main app
        # lesli_application_stylesheet_path(:lesli)         -> stylesheet from Lesli
        # lesli_application_stylesheet_path(:engine) (TODO) -> stylesheet from engine current
        # lesli_application_stylesheet_path(:cloud_driver)  -> stylesheet from engine specific
        def lesli_application_stylesheet_path(engine = nil)
            return "#{engine}/templates/application" if engine

            "#{lesli_engine(:code)}/application"
        end

        # Return a string path to load the main engine stylesheet
        def application_stylesheet_engine_path
            lesli_engine = lesli_engine(:code)
            return "administration/application" if is_lesli_administration?
            return "onboardings/application" if is_lesli_onboarding?

            "#{lesli_engine}/application"
        end

        # Return a string path to load the main javascript app of the engine
        def lesli_application_javascript_path
            # get the namespace to load specific javascript file
            # for engine or specific javascript file for core controller
            path_segments = controller_path.split("/")
            lesli_engine = path_segments.shift

            return "onboardings/application" if is_lesli_onboarding?

            "#{lesli_engine}/application"
        end

        def javascript_googlemaps_sdk
            "<script type=\"application/javascript\" src=\"https://maps.googleapis.com/maps/api/js?key=#{Rails.application.credentials.dig(
                :providers, :google, :maps_sdk_token
            )}\"></script>".html_safe
        end

        def javascript_apple_mapkit_js
            token = Rails.application.credentials.dig(:providers, :apple, :mapkit_token)

            "<script type=\"application/javascript\" src=\"https://cdn.apple-mapkit.com/mk/5.45.0/mapkit.js\"></script>
            <script type=\"application/javascript\">
                const ampkt = \"#{token}\"
            </script>".html_safe
        end

        def favicon
            icon_path = customization_instance_logo_url(logo: "favicon")
            "
            <link href=\"#{icon_path}\" rel=\"alternate icon\">
            <link href=\"#{icon_path}\" rel=\"icon\" type=\"image/svg+xml\">
            <link href=\"#{icon_path}\" rel=\"mask-icon\" color=\"#ff8a01\">
            ".html_safe
        end
    end
end
