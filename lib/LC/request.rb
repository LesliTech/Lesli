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

module LC

    class Request
        
        def self.locale http_accept_language=nil

            # if language was not sent, return default language
            return I18n.locale if http_accept_language.blank?

            # scan string looking for language
            http_accept_language = http_accept_language.scan(/^[a-z]{2}/).first

            # if language not found, return default language
            return I18n.locale if http_accept_language.blank?

            # if requested language is not in the list of available languages
            return http_accept_language if I18n.available_locales.include?(http_accept_language.to_sym)

        end

        def self.user_agent http_user_agent, as_string: true

            # How to use this gem?
            # UserAgent.parse(request.env["HTTP_USER_AGENT"])

            # parse user agent
            user_agent = UserAgent.parse(http_user_agent)

            # return user agent info as string
            return "#{user_agent.platform} #{user_agent.os} - #{user_agent.browser} #{user_agent.version}" if as_string == true

            user_agent

        end

    end
end
