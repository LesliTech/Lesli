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

    def application_body_class()
        application_body_class = lesli_instance_code
        [application_body_class, controller_path.gsub("/","-"), action_name].join(" ")
    end

    def website_title

        title = @application_html_title || controller_path.gsub("cloud","").gsub("_", "")
        title_prefix = Rails.application.config.lesli.dig(:account, :website, :title_prefix)

        ("<title>" + title_prefix + " · " + title + "</title>").html_safe

    end

    def language_url(locale)
        "/language?locale=#{locale}"
    end

    def language_flag(locale)
        locale = "gb" if locale.to_s == "en"
        locale
    end

    def language_name(locale)
        Rails.application.config.lesli.dig(:configuration, :locales_available, locale.to_s) || "undefined"
    end

    def lesli_icon(name)
        lesli_svg("icons/lesli/icon-#{name}")
    end

    def lesli_svg(name)
        file_path = "#{Rails.root}/app/assets/#{name}.svg"
        return File.read(file_path).html_safe if File.exists?(file_path)
        '(not found)'
    end

end
