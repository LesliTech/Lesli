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

    layout "layouts/application-public"

    def initialize

        super

        @account = {
            tasks: 0,
            cable: false,
            company: {},
            settings: {},
            revision: {},
            current_user: {},
            notifications: 0,
            announcements: 0,
            customization: {
                logo: "/images/brand/lesli-name.svg", 
                color_primary: "#3689e6"
            }
        }

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
