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

Lesli · Ruby on Rails SaaS Development Framework.

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

        add_flash_types(:info, :danger, :success, :warning)

        attr_reader :query
        attr_reader :engine_path

        def initialize
            super
            @lesli = {}
        end

        # Meta-programming to define flash setter methods dynamically
        # success("Everything worked!")
        # danger("Oops, there was an error.")
        # info("Just an informational message.")
        # warning("This is a warning.")
        [:success, :danger, :warning, :info].each do |flash_type|
            define_method(flash_type) do |message|
                flash[flash_type] = message
            end
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

            redirect_back(fallback_location: request.referer)

            # This code is not really executed
            # respond_with_successful({
            #                             locale: I18n.locale,
            #                             default_locale: I18n.default_locale,
            #                             available_locales: I18n.available_locales
            #                         })
        end

        # # Set the user language based on url configuration or browser/os default language (ready for public pages)
        # def set_locale
        #     # language defined in the http header request
        #     locale = request.headers["Require-Language"] unless request.headers["Require-Language"].blank?

        #     # use locale defined in the url
        #     locale = params[:locale] if locale.blank?

        #     # use the language from the browser/os
        #     locale = browser_locale if locale.blank?

        #     # use the default locale if no custom locale was found
        #     return I18n.locale = I18n.default_locale if locale.blank?

        #     # use default locale if requested language is not supported
        #     return I18n.locale = I18n.default_locale unless I18n.available_locales.include?(locale.to_sym)

        #     # set the new locale
        #     I18n.locale = locale
        # end

        # protected

        # def browser_locale
        #     # get user's preferred language from browser
        #     user_browser_locale = request.headers["HTTP_ACCEPT_LANGUAGE"] || request.headers["Accept-Language"] || ""

        #     # extract locale from accept language header
        #     user_browser_locale.scan(/^[a-z]{2}/).find do |locale|
        #         # validate if browser language is in the list of supported languages
        #         I18n.available_locales.include?(locale.to_sym)
        #     end
        # end
    end
end
