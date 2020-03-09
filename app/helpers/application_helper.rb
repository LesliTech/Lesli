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

    def app_css_class_for_body()
        d = defined?(CloudHaus) ? "CloudHaus" : "LesliCloud"
        d+= " "
        d+= controller_path.gsub('/','-')
        d+= " "
        d+= action_name
    end

    def app_theme_stylesheet_path()

        theme = "themes/blank"

        unless @account[:settings]['theme'].blank?
            theme = "themes"
            theme+= "/"
            theme+= @account[:settings]['theme']
            theme+= "/"
            theme+= @account[:settings]['theme_variation'].blank? ? "standard" : @account[:settings]['theme_variation']
            theme+= "/"
            theme+= @account[:settings]['theme']
        end

        theme

    end

    def application_header_logo() 
        
        image_src_string = "brand/lesli-logo-banner.svg"
        image_src_string = "cloud_haus/brand/deutsche-leibrenten-logo.png" if defined?(CloudHaus)
        image_src_string
        
    end

end
