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

    # print a custom icon for lesli
    def lesli_svg(name)
        content_tag("svg", :width => "64px", :height => "64px") do 
            "<use xlink:href='##{name}'></use>".html_safe
        end
    end 

    def application_body_class()
        website_body_class()
    end

    # return a string with a css class to identify the body
    # example: builder engine-controller action
    def website_body_class()
        application_body_class = lesli_instance_code
        [application_body_class, controller_path.gsub("/","-"), action_name].join(" ")
    end

    # build the text for the html document title
    # this helper works only for rails pages, for vue apps the title must be handled with JS
    def website_title
        return @application_html_title if @application_html_title
        title = controller_path.gsub("cloud","").gsub("_", "")
        prefix = @account.dig(:company, :name)
        "#{prefix} - #{title}"
    end

    # build description using custom data from controller or engine gem description
    def website_meta_description
        # if want to get description from gem you can use:
        # Gem::Specification.find_by_name(engine_name).description
        # Gem::Specification.find_by_name(engine_name).summary
        @application_html_description || ""
    end

end
