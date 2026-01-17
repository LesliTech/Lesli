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
    module RequesterInterface

        def set_path
            # @@engine_path = Lesli::Engine.routes.find_script_name({})
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
            # locale = current_user.locale if warden.authenticated?

            # language defined in the http header request
            locale = request.headers["Require-Language"] unless request.headers["Require-Language"].blank?

            # use default locale if requested language is not supported
            locale = I18n.default_locale unless I18n.available_locales.include?(locale.to_sym)

            # set the new locale
            I18n.locale = locale
        end

        # Set default query params for:
        def set_requester
            @query = {
                :search => params[:search] || nil,
                :pagination => {
                    :perPage => (params[:perPage] ? params[:perPage].to_i : 12),
                    :page => (params[:page] ? params[:page].to_i : 1)
                },
                :order => {
                    :by => (params[:orderBy] || "id"),
                    :dir => (params[:order] || "desc")
                }
            }
        end
    end
end
