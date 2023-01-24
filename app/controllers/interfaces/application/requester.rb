=begin
Copyright (c) 2023, all rights reserved.
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

module Interfaces
    module Application
        module Requester

            # Set default query params for:
            #   pagination
            #   sorting
            #   filtering
            def set_helpers_for_request
                @query = {
                    search: params[:search] || "",
                    filters: params[:f] ? params[:f] : {},
                    pagination: {
                        perPage: (params[:perPage] ? params[:perPage].to_i : 10),
                        page: (params[:page] ? params[:page].to_i : 1)
                    },
                    order: {
                        by: (params[:orderBy] ? params[:orderBy] : "id"),
                        dir: (params[:order] ? params[:order] : "desc")
                    },
                    group: params[:group] || ""
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
                locale = I18n.default_locale unless I18n.available_locales.include?(locale.to_sym)

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
end
