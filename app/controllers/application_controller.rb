=begin

Lesli

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

class ApplicationController < ActionController::Base

    before_action :set_locale

    layout "layouts/application-public"
 
    def set_locale

        # get saved language in session or the default in config
        # the session param is setted in settings controller through "get :language, to: "settings#language""
        locale = session[:locale] || I18n.default_locale

        # Here I should check user preference for language settings
        # the options are
            # - I18n.available_locales
            # - automatic according to os or browser

        # set the new locale
        I18n.locale = locale

    end

    def switch_locale

        local = I18n.locale

        # check if param locale was sent by the user
        if not params[:locale].blank?

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

        respond_with_successful({
            locale: I18n.locale,
            default_locale: I18n.default_locale, 
            available_locales: I18n.available_locales
        })

    end

end
