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
        title = @application_html_title || [controller_path.gsub("cloud","").gsub("_", ""), action_name].join("/")
        title = title + " · " + Rails.application.config.lesli_settings["account"]["website"]["title_suffix"]
        title
    end

    def application_body_class()
        application_body_class = lesli_instance
        [application_body_class, controller_path.gsub("/","-"), action_name].join(" ")
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

    def lesli_instance(company_name=nil)
        return Rails.application.config.lesli_settings["info"]["name"] === company_name if not company_name.blank?
        return Rails.application.config.lesli_settings["info"]["name"]
    end

end
