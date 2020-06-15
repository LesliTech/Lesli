=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class ApplicationController < ActionController::Base

    rescue_from ActiveRecord::RecordNotFound, with: :responseWithSuccessful

    before_action :set_locale
 
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

        responseWithSuccessful({
            locale: I18n.locale,
            default_locale: I18n.default_locale, 
            available_locales: I18n.available_locales
        })

    end


    # JSON successful response
    def responseWithSuccessful(data = nil)
        response_body = { successful: true }
        response_body[:data] = data
        render status: 200, json: response_body.to_json
    end
    
    # JSON failure response
    def responseWithError(message = "", details = [])
        render status: 200, json: {
            successful: false,
            error: {
                message: message,
                details: details
            }
        }.to_json
    end

    # JSON not found response
    def responseWithNotFound
        render status: 404, json: {
            successful: false,
            error: {
                message: I18n.t("core.shared.not_found_error_message"),
                details: []
            }
        }.to_json
    end

    # JSON not found response
    def responseWithUnauthorized
        respond_to do |format|
            format.html { redirect_to "/401" }
            format.json { 
                render status: 401, json: {
                    successful: false,
                    error: {
                        message: I18n.t("core.shared.unauthorized_error_message"),
                        details: []
                    }
                }.to_json
            }
        end
    end

    def response_with_successful(response = nil)

        response_body = { }

        # transaction completed successfully
        response_body[:successful] = true 

        # build pagination for array response
        if response.is_a?(Array) 

            # pagination results (most for index only)
            response_body[:records] = {} 
            response_body[:records][:found] = response.length
            response_body[:records][:total] = response.length
            response_body[:data] = response

        end

        # build pagination for hash results
        if response.is_a?(Hash) 

            # hash result with pagination
            if response[:total] || response[:found]
                response_body[:records] = {} 
                response_body[:records][:found] = response[:found] || response[:data].length || 1
                response_body[:records][:total] = response[:total] || response_body[:records][:found] 
                response_body[:data] = response[:data]
            else

                # simple hash result
                response_body[:records] = {} 
                response_body[:records][:found] = 1
                response_body[:records][:total] = 1
                response_body[:data] = response
            end 

        end

        # render response 
        render status: 200, json: response_body.to_json

    end

    private

    def get_browser_locale
        accept_language = request.env["HTTP_ACCEPT_LANGUAGE"]
        return unless accept_language
        accept_language.scan(/^[a-z]{2}/).first
    end

end
