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
    def application_stylesheet_template_path

        template = "application"

        # the main core features must work with the core 3
        if (is_lesli_onboarding?() || is_lesli_administration?() || lesli_engine2()[:core] == 3)
            template = "application3"
        end

        ["templates", template].join("/")

    end


    # Return a string path to load the stylesheet of the selected theme
    def application_stylesheet_theme_path()

        theme = "themes/blank"

        # check if instance has a custom theme defined
        custom = Rails.application.config.lesli.dig(:configuration, :theme)

        # if not cusotm theme defined, use an emtpy theme
        return theme if custom.blank?

        # build and return custom theme
        ["themes", custom, custom].join("/")

    end


    # Return a string path to load the stylesheet corresponding to the controller app
    def application_stylesheet_engine_path

        path_segments = controller_path.split("/")
        cloud_module = path_segments.shift

        template = "application"

        if is_lesli_administration?
            return ["administration", template].join("/")
        end 

        if is_lesli_onboarding?
            return ["onboardings", template].join("/")
        end 

        [cloud_module, template].join("/")

    end

    # Return a string path to load the main javascript app of the engine
    def application_javascript_path

        path_segments = controller_path.split("/")
        cloud_module = path_segments.shift

        if is_lesli_administration?
            return ["administration", "application"].join("/")
        end 

        if is_lesli_onboarding?
            return ["onboardings", "application"].join("/")
        end 

        return [cloud_module, "application"].join("/")

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
