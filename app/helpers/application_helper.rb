=begin

Copyright (c) 2020, all rights reserved.

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

module ApplicationHelper


    def lesli_instance_code()
        LC::System::Info.instance[:code]
    end

    def application_body_class()
        application_body_class = lesli_instance_code
        [application_body_class, controller_path.gsub("/","-"), action_name].join(" ")
    end

    def application_stylesheet_theme_path()

        theme = "themes/blank"

        unless Rails.application.config.lesli_settings["configuration"]["theme"].blank?
            theme = [
                "themes",
                Rails.application.config.lesli_settings["configuration"]["theme"],
                Rails.application.config.lesli_settings["configuration"]["theme"]
            ].join("/")
        end

        theme

    end

    def application_stylesheet_path

        path_segments = controller_path.split("/")
        cloud_module = path_segments.shift

        # @TODO: See Trello card 2450. We must migrate all functionallity to
        # this.data and remove this.bus before enabling help for a global JS file
        if [
            "cloud_text", "cloud_house", "cloud_babel",
            "cloud_audit", "cloud_realty", "cloud_bell",
            "cloud_mailer", "cloud_kb"
        ].include?(cloud_module)
            return [cloud_module, [cloud_module, "app"].join("_")].join("/")
        end

        controller_path
    end

    def application_javascript_path

        path_segments = controller_path.split("/")
        cloud_module = path_segments.shift

        # @TODO: See Trello card 2450. We must migrate all functionallity to
        # this.data and remove this.bus before enabling help for a global JS file
        if [
            "cloud_text", "cloud_house", "cloud_babel",
            "cloud_audit", "cloud_realty", "cloud_bell",
            "cloud_mailer", "cloud_kb"
        ].include?(cloud_module)
            return [cloud_module, [cloud_module, "app"].join("_")].join("/")
        end

        path_segments = controller_path.split("/")
        cloud_module = path_segments.shift
        [cloud_module, path_segments.push("app").compact().join("_")].join("/")

    end

    def lesli_engine()
        controller_path.split('/')[0]
    end

    def is_lesli_engine_administration?
        [
            "accounts", "account", "roles", "profiles", "users", "abouts", 
            "settings", "cronos", "onboarding", "role_descriptors"
        ].include?(lesli_engine)
    end

    def is_lesli_engine?(engine=nil)
        current_engine = lesli_engine
        return current_engine == engine if not engine.blank?
        return false if is_lesli_engine_administration?
        return true
    end

    # return the name of the engine loaded for the current path
    # this helper return the name of the engine of the code we are running on
    # example: https://lesli.cloud/driver/events/1/edit -> engine loaded: cloud_driver
    def lesli_engine_or_instance
        return lesli_instance_code if not is_lesli_engine?
        return lesli_engine
    end


    # The code below need to be reviewed and refactored to work with gems instead of engines


    def website_title

        title = @application_html_title || controller_path.gsub("cloud","").gsub("_", "")
        title_prefix = Rails.application.config.lesli_settings["account"]["website"]["title_prefix"]

        ("<title>" + title_prefix + " · " + title + "</title>").html_safe

    end

    def nav_link(link_path)
        class_name = current_page?(link_path) ? "is-active" : nil
        content_tag(:li) do
            content_tag(:a, :href => link_path, :class => class_name) do
                yield
            end
        end
    end

    def language_url(locale)
        "/language?locale=#{locale}"
    end

    def language_flag(locale)
        locale = "gb" if locale.to_s == "en"
        locale
    end

    def language_name(locale)
        Rails.application.config.lesli_settings["configuration"]["locales_available"][locale.to_s] || "undefined"
    end

    def javascript_googlemaps_sdk
        "<script src=\"https://maps.googleapis.com/maps/api/js?key=#{Rails.application.credentials.dig(:providers, :google, :maps_sdk_token)}\"></script>".html_safe
    end

    def favicon
        icon_path = customization_instance_logo_url(logo: "favicon")
        ("
        <link href=\"#{icon_path}\" rel=\"alternate icon\">
        <link href=\"#{icon_path}\" rel=\"icon\" type=\"image/svg+xml\">
        <link href=\"#{icon_path}\" rel=\"mask-icon\" color=\"#ff8a01\">
        ").html_safe
    end

    def is_lesli_instance?(instance=nil, engine=nil)

        # return instance name
        return Rails.application.config.lesli_settings["info"]["name"] if instance.blank? and engine.blank?

        # current engine id
        current_engine = controller_path.split('/')[0]

        # validate instance
        if Rails.application.config.lesli_settings["info"]["name"] == instance and engine.blank?
            return true
        end

        # validate instance and engine
        if Rails.application.config.lesli_settings["info"]["name"] == instance and current_engine == engine
            return true
        end

        return false

    end

    def integration_access_token(integration_name)
        return Rails.application.credentials.integrations[integration_name][:access_token]
    end

end
