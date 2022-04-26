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

    def application_stylesheet_template_path

        template = "application"

        if [
            "lesli_cloud", 
            "cloud_audit",
            "cloud_development"
        ].include?(lesli_engine)
            template = "application3"
        end 

        ["templates", template].join("/")

    end

    def application_stylesheet_theme_path()

        theme = "themes/blank"

        # check if instance has a custom theme defined
        custom = Rails.application.config.lesli.dig(:configuration, :theme)

        # if not cusotm theme defined, use an emtpy theme
        return theme if custom.blank?

        # build and return custom theme
        ["themes", custom, custom].join("/")

    end

    def application_stylesheet_engine_path

        path_segments = controller_path.split("/")
        cloud_module = path_segments.shift

        if [
            "accounts", "account", "roles", "profiles", "users", "abouts", 
            "settings", "cronos", "onboarding", "role_descriptors"
        ].include?(cloud_module)
            return controller_path 
        end 

        template = "application"

        if ["lesil_cloud"].include?(lesli_engine)
            template = "application3"
        end 

        [cloud_module, "application"].join("/")

    end

    def application_javascript_path

        path_segments = controller_path.split("/")
        cloud_module = path_segments.shift

        if ["account"].include?(cloud_module)
            return [cloud_module, path_segments.push("application").compact().join("_")].join("/")
        end 

        return [cloud_module, "application"].join("/")

    end

    def javascript_googlemaps_sdk
        "<script type=\"application/javascript\" src=\"https://maps.googleapis.com/maps/api/js?key=#{Rails.application.credentials.dig(:providers, :google, :maps_sdk_token)}\"></script>".html_safe
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
