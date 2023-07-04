=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
