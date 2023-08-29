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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·
=end

module Lesli
    class ApplicationController < ActionController::Base
        layout "lesli/layouts/application-public"

        def initialize
            super
            @lesli = {}
        end

        def language
            # check if param locale was sent by the user
            unless params[:locale].blank?

                locale = params[:locale].to_sym

                # check if locale requested is valid
                if I18n.available_locales.include?(locale)

                    # save requested locale in session
                    # this will be used in application_controller#switch_locale
                    session[:locale] = locale

                end

            end

            I18n.locale = locale

            return redirect_back(fallback_location: root_authenticated_path)

            # This code is not really executed
            # respond_with_successful({
            #                             locale: I18n.locale,
            #                             default_locale: I18n.default_locale,
            #                             available_locales: I18n.available_locales
            #                         })
        end
    end
end
