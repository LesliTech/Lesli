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
                search: params[:search] || "",
                filters: params[:filters] ? params[:filters] : {},
                pagination: {
                    perPage: (params[:perPage] ? params[:perPage].to_i : 15),
                    page: (params[:page] ? params[:page].to_i : 1),
                    order: (params[:order] ? params[:order] : "desc"),
                    orderBy: (params[:orderBy] ? params[:orderBy] : "id"),
                    orderColumn: (params[:orderColumn] ? params[:orderColumn] : "id")
                },
                order: {
                    by: (params[:orderBy] ? params[:orderBy] : "id"),
                    dir: (params[:order] ? params[:order] : "desc")
                }
            }

            # compatibility with lesli 2
            @query[:filters][:search] = @query[:search] unless @query[:filters][:search]
        end


        def set_locale

            # get saved language in session, browser language or the default in config
            # the session param is setted in settings controller through "get :language, to: "settings#language""
            locale = session[:locale] || I18n.default_locale

            # get user's preferred language
            # IMPORTANT: 
            #       Here it's not possible to use the methods provided by devise to check if user is 
            #       authetnicated "user_signed_in", due those methods redirects to the login controller
            #       if user is not authenticated; For some scenarios we need to have control of the behavior 
            #       for not authenticated user requests, thats why here we go deeper and check if user is 
            #       authenticated checking the warden storage
            locale = current_user.locale || locale if warden.authenticated?
    
            # language defined by the request from user settings
            if not request.headers["Require-Language"].blank?
                locale = request.headers["Require-Language"]
            end

            # use default locale if requested language is not supported
            locale = I18n.default_locale if not I18n.available_locales.include?(locale.to_sym)
    
            # set the new locale
            I18n.locale = locale
    
        end

        private 

        def get_browser_locale
            # get user's preferred language from browser
            browser_locale = request.headers['HTTP_ACCEPT_LANGUAGE'] || request.headers['Accept-Language'] || ""
            browser_locale = browser_locale.scan(/[a-z]{2}(?=;)/).find do |locale|
                I18n.available_locales.include?(locale.to_sym)
            end
        end

    end

end
