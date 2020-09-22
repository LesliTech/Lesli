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

    # DEPRECATED
    # use LC::Response.pagination in combination with respond_with_successful instead
    def respond_with_pagination data
        respond_with_successful(data)
    end

    def respond_with_successful data= nil
        response_body = { successful: true }
        response_body[:data] = data
        render status: 200, json: response_body.to_json
    end
    
    # JSON failure response
    def respond_with_error message = "", details = []
        render status: 200, json: {
            successful: false,
            error: {
                message: message,
                details: details
            }
        }.to_json
    end

    # JSON not found response
    def respond_with_not_found
        render status: 404, json: {
            successful: false,
            error: {
                message: I18n.t("deutscheleibrenten.shared.not_found_error_message"),
                details: []
            }
        }.to_json
    end

    # JSON not found response
    def respond_with_unauthorized(detail = {})
        error_object = {
            successful: false,
            error: {
                message: I18n.t("deutscheleibrenten.shared.unauthorized_error_message")
            }
        }

        if Rails.env == "development"
            error_object[:error][:role] = current_user.role.detail.name
            error_object[:error][:detail] = detail
        end

        respond_to do |format|
            format.json { render status: 401, json: error_object.to_json }
            format.html { redirect_to "/401" } if Rails.env == "production"
            format.html { render status: 401, json: error_object.to_json }
        end
    end

    # Define platform version according to builder module
    def get_revision

        version = 0
        build = 0

        if defined?(DeutscheLeibrenten)
            version = DeutscheLeibrenten::VERSION
            build = DeutscheLeibrenten::BUILD
        end

        return {
            version: version,
            build: build
        }

    end

    def get_client_info as_string=false
        user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
        #p "Browser:" + user_agent.browser # Firefox
        #p "Version:" + user_agent.version # 22.0
        #p "Platform:" + user_agent.platform # Macintosh
        #p "Mobile:" + (user_agent.mobile?).to_s # False
        #p "OS:" + user_agent.os # OS X 10.8
        return "#{user_agent.platform} #{user_agent.os} - #{user_agent.browser} #{user_agent.version}" if as_string
    end

    private

    def get_browser_locale
        accept_language = request.env["HTTP_ACCEPT_LANGUAGE"]
        return unless accept_language
        accept_language.scan(/^[a-z]{2}/).first
    end

end
