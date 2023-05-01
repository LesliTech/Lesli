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

module Interfaces
    module Application
        module Requester

            # Set default query params for:
            def set_helpers_for_request
                @query = {
                    search: params[:search] || nil,
                    pagination: {
                        perPage: (params[:perPage] ? params[:perPage].to_i : 25),
                        page: (params[:page] ? params[:page].to_i : 1)
                    },
                    order: {
                        by: (params[:orderBy] ? params[:orderBy] : "id"),
                        dir: (params[:order] ? params[:order] : "desc")
                    }
                }
            end


            # Set the user language based on user_settings, session configuration or instance default locale
            def set_locale

                # get saved language in session, browser language or the default in config
                # the session param is setted in settings controller through "get :language, to: "settings#language""
                locale = session[:locale] || I18n.default_locale

                # get user's preferred language
                # IMPORTANT:
                #       Here it's not possible to use the methods provided by devise to check if user is
                #       authenticated "user_signed_in", due those methods redirects to the login controller
                #       if user is not authenticated; For some scenarios we need to have control of the behavior
                #       for not authenticated user requests, thats why here we go deeper and check if user is
                #       authenticated checking the warden storage
                locale = current_user.locale if warden.authenticated?

                # language defined in the http header request
                unless request.headers["Require-Language"].blank?
                    locale = request.headers["Require-Language"]
                end

                # use default locale if requested language is not supported
                locale = I18n.default_locale unless I18n.available_locales.include?(locale.to_sym)

                # set the new locale
                I18n.locale = locale

            end

            # Set the user language based on url configuration or browser/os default language
            def set_locale_public

                # language defined in the http header request
                unless request.headers["Require-Language"].blank?
                    locale = request.headers["Require-Language"]
                end

                # use locale defined in the url
                locale = params[:locale] if locale.blank?

                # use the language from the browser/os
                locale = get_browser_locale if locale.blank?

                # use the default locale if no custom locale was found
                return I18n.locale = I18n.default_locale if locale.blank?

                # use default locale if requested language is not supported
                return I18n.locale = I18n.default_locale unless I18n.available_locales.include?(locale.to_sym)

                # set the new locale
                I18n.locale = locale
        
            end

            private

            def get_browser_locale

                # get user's preferred language from browser
                browser_locale = request.headers['HTTP_ACCEPT_LANGUAGE'] || request.headers['Accept-Language'] || ""

                # extract locale from accept language header
                browser_locale = browser_locale.scan(/^[a-z]{2}/).find do |locale|
                    
                    # validate if browser language is in the list of supported languages
                    I18n.available_locales.include?(locale.to_sym)
                end

                browser_locale
            end

        end
    end
end
