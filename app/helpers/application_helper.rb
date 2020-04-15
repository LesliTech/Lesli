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

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
    
=end

module ApplicationHelper

    def application_body_class()
        application_body_class = "LesliTech"

        application_body_class = "CloudHaus" if defined?(CloudHaus)

        [application_body_class, controller_path.gsub('/','-'), action_name].join(' ')
        
    end

    def application_stylesheet_path()

        theme = "themes/blank"

        unless @account[:settings]['theme'].blank?
            theme = "themes"
            theme+= "/"
            theme+= @account[:settings]['theme']
            theme+= "/"
            theme+= @account[:settings]['theme_variation']
            theme+= "/"
            theme+= "theme"
        end

        theme

    end

    def application_javascript_path

        path_segments = controller_path.split("/")
        cloud_module = path_segments.shift
        [cloud_module, path_segments.push("app").compact().join("_")].join("/")

    end

    def application_header_logo() 
        
        image_src_string = "brand/lesli-logo-banner.svg"
        image_src_string = "cloud_haus/brand/deutsche-leibrenten-logo.png" if defined?(CloudHaus)
        image_src_string
        
    end

    def company(company_name)
        company = "LesliTech"
        company = "CloudHaus" if defined?(CloudHaus)
        company == company_name
    end

    def language_url(locale)
        "/language?locale=#{locale}"
    end

    def language_flag(locale)
        locale = "gb" if locale.to_s == "en"
        locale
    end

    def language_name(locale)
        locale = "English"  if locale.to_s == "en"
        locale = "Deutsche" if locale.to_s == "de"
        locale = "Español"  if locale.to_s == "es"
        locale
    end

    def javascript_googlemaps_sdk
        '<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCN4i4BWJS-IVtniSMY1Ot2MGaKuTKLNP8"></script>'.html_safe
    end

end
