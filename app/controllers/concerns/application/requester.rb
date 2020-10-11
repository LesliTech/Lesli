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

module Application

    module Requester
        extend ActiveSupport::Concern

        included do
        end

        # Set default query params for:
        #   pagination
        #   sorting
        #   filtering
        def set_helpers_for_request
            @query = {
                filters: params[:filters] ? params[:filters] : {},
                pagination: {
                    perPage: (params[:perPage] ? params[:perPage].to_i : 15),
                    page: (params[:page] ? params[:page].to_i : 1),
                    order: (params[:order] ? params[:order] : "desc"),
                    orderColumn: (params[:orderColumn] ? params[:orderColumn] : "id")
                }
            }
        end


        def set_locale

            # get saved language in session or the default in config
            # the session param is setted in settings controller through "get :language, to: "settings#language""
            locale = session[:locale] || I18n.default_locale
    
            # language defined by the request
            if not request.headers["Require-Language"].blank?
                locale = request.headers["Require-Language"]
            end

            # Here should I check?
                # browser language?
                # database language?

            # use default locale if requested language is not supported
            locale = I18n.default_locale if not I18n.available_locales.include?(locale.to_sym)
    
            # set the new locale
            I18n.locale = locale
    
        end

    end

end
