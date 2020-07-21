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

module ApplicationHelper

    def website_title

        title_string = -> () {
            title = @application_html_title || controller_path.gsub("cloud","").gsub("_", "")
            return title if Rails.application.config.lesli_settings["account"]["website"].blank?
            return title if Rails.application.config.lesli_settings["account"]["website"]["title_suffix"].blank?
            return title + " · " + Rails.application.config.lesli_settings["account"]["website"]["title_suffix"]
        }

        ("<title>"+ title_string.call() +"</title>").html_safe

    end

    def application_body_class()
        application_body_class = lesli_instance
        [application_body_class, controller_path.gsub("/","-"), action_name].join(" ")
    end

    def nav_link(link_path)
        class_name = current_page?(link_path) ? "is-active" : nil
        content_tag(:li) do
            content_tag(:a, :href => link_path, :class => class_name) do
                yield
            end
        end
    end

    def application_stylesheet_theme_path()

        theme = "themes/blank"

        unless @account[:settings]["theme"].blank?
            theme = [
                "themes", 
                @account[:settings]["theme"],
                @account[:settings]["theme"]
            ].join("/")
        end

        theme

    end

    def application_javascript_path

        path_segments = controller_path.split("/")
        cloud_module = path_segments.shift
        [cloud_module, path_segments.push("app").compact().join("_")].join("/")

    end

    def language_url(locale)
        "/language?locale=#{locale}"
    end

    def language_flag(locale)
        locale = "gb" if locale.to_s == "en"
        locale
    end

    def language_name(locale)
        return "English"  if locale.to_s == "en"
        return "Deutsche" if locale.to_s == "de"
        return "Español"  if locale.to_s == "es"
        return "undefined"
    end

    def javascript_googlemaps_sdk
        "<script src=\"https://maps.googleapis.com/maps/api/js?key=AIzaSyCN4i4BWJS-IVtniSMY1Ot2MGaKuTKLNP8\"></script>".html_safe
    end

    def favicon
        ("
        <link href=\"/images/favicon/"+lesli_instance.downcase+".svg\" rel=\"alternate icon\">
        <link href=\"/images/favicon/"+lesli_instance.downcase+".svg\" rel=\"icon\" type=\"image/svg+xml\">
        <link href=\"/images/favicon/"+lesli_instance.downcase+".svg\" rel=\"mask-icon\" color=\"#ff8a01\">
        ").html_safe
        
    end

    def lesli_instance(instance=nil, engine=nil)

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

end
