=begin

Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module AssetsHelper

    # Return a string path to load the template stylesheet
    # by default we always return the latest version of the template
    def application_stylesheet_template_path
        "templates/application3"
    end


    # Return a string path to load the main engine stylesheet
    def application_stylesheet_engine_path

        cloud_module = lesli_engine(:code)
        return "administration/application" if is_lesli_administration?
        return "onboardings/application" if is_lesli_onboarding?
        return "#{cloud_module}/application"

    end

    # Return a string path to load the main javascript app of the engine
    def application_javascript_path version=nil

        cloud_module = lesli_engine(:code)

        return "administration/application" if is_lesli_administration?
        return "onboardings/application" if is_lesli_onboarding?

        return "#{cloud_module}/application-#{version}" if version
        return "#{cloud_module}/application"

    end

    def javascript_googlemaps_sdk
        "<script type=\"application/javascript\" src=\"https://maps.googleapis.com/maps/api/js?key=#{Rails.application.credentials.dig(:providers, :google, :maps_sdk_token)}\"></script>".html_safe
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
        ("
        <link href=\"#{icon_path}\" rel=\"alternate icon\">
        <link href=\"#{icon_path}\" rel=\"icon\" type=\"image/svg+xml\">
        <link href=\"#{icon_path}\" rel=\"mask-icon\" color=\"#ff8a01\">
        ").html_safe
    end

end
