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

module HtmlHelper

    # return a string with a css class to identify the body
    # example: builder engine-controller action
    def application_body_class()
        application_body_class = lesli_instance_code
        [application_body_class, controller_path.gsub("/","-"), action_name].join(" ")
    end

    # build the text for the html document title
    def website_title
        title = @application_html_title || controller_path.gsub("cloud","").gsub("_", "")
        title_prefix = Rails.application.config.lesli.dig(:account, :website, :title_prefix)
        title_prefix.concat(" · ").concat(title)
    end

    # build a url path to change locales
    def language_url(locale)
        "/language?locale=#{locale}"
    end

    # return flag code according to locale code
    def language_flag(locale)
        locale = "gb" if locale.to_s == "en"
        locale
    end

    # return the name of the language
    def language_name(locale)
        Rails.application.config.lesli.dig(:configuration, :locales_available, locale.to_sym) || "undefined"
    end

end
