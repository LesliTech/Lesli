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

class ApplicationApiController < ActionController::API

    before_action :authorize_request
    before_action :authorize_privileges
    before_action :set_request_helpers
    after_action :log_user_requests

    @current_user = nil
    @current_session = nil

    def respond_with_successful data=nil
        response_body = { successful: true }
        response_body[:data] = data if data
        render status: 200, json: response_body.to_json
    end
    
    # JSON failure response
    def respond_with_error message="", details=[]
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
                message: I18n.t("core.shared.not_found_error_message"),
                details: []
            }
        }.to_json
    end

    # JSON unauthorized response
    def respond_with_unauthorized(detail = {})
        error_object = {
            successful: false,
            error: {
                message: I18n.t("core.shared.unauthorized_error_message")
            }
        }

        if Rails.env == "development"
            error_object[:error][:role] = current_user.role.detail.name if current_user
            error_object[:error][:detail] = detail
        end

        render status: 401, json: error_object.to_json
    end

    # set query used to filter or sort data requests
    def set_request_helpers
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

    # Track all user activity
    # this is disabled by default in the settings file
    def log_user_requests

        return if !Rails.application.config.lesli_settings["configuration"]["security"]["log_activity"]

        return if @current_user.blank?

        @current_user.requests.create({
            session_uuid: @current_session[:session_uuid],
            request_uuid: request.uuid,
            request_controller: controller_path,
            request_method: request.method,
            request_action: action_name, 
            request_url: request.original_fullpath, 
            #params: request.params
        })

    end

    # Track all user activity
    # this is disabled by default in the settings file
    def log_user_activity description=nil

        return if !Rails.application.config.lesli_settings["configuration"]["security"]["log_activity"]

        return if @current_user.blank?

        @current_user.logs.create({
            session_uuid: @current_session[:session_uuid],
            request_uuid: request.uuid,
            description: description
        })

    end

    # Track specific account activity
    # this is disabled by default in the settings file
    def log_account_activity system_module, system_process, description=nil, payload=nil

        return if !Rails.application.config.lesli_settings["configuration"]["security"]["log_activity"]

        account = Account.first

        account.activities.create({
            system_module: system_module,
            system_process: system_process,
            description: description,
            payload: payload
        })

    end

    private

    def authorize_request

        # check headers for Authorization token
        if not request.headers['Authorization'].present?
            return respond_with_unauthorized "Not valid authorization token found"
        end

        # get token sent to validate the request
        token = request.headers["Authorization"].split("Bearer ").last

        token = LC::System::Jwt.decode(token)

        if not token.successful?
            return respond_with_unauthorized "Not valid authorization token found"
        end

        @current_session = User::Session.find_by(
            :user_uuid => token.payload[0]["sub"],
            :session_uuid => token.payload[0]["jti"]
        )

        if @current_session.blank?
            return respond_with_unauthorized "Not valid authorization token found"
        end

        @current_user = @current_session.user

        if @current_user.blank?
            return respond_with_unauthorized "Not valid authorization token found"
        end

        token

    end

    # Check if current_user has privileges to complete this request
    # allowed core methods:
    #   [:index, :create, :update, :destroy, :new, :show, :edit, :options, :search, :resources]
    def authorize_privileges

        return true

        action = params[:action]
        action = "resources" if request.path.include?("resources")

        granted = current_user.privileges
        .where("role_privileges.grant_object = ?", params[:controller])
        .where("role_privileges.grant_#{action} = TRUE")
        .first

        # empty privileges if null privileges
        granted ||= {} 

        # if user do not has access to the requested route and can go to default route        
        if !granted["grant_#{action}"] === true && can_redirect_to_default_path
            return redirect_to current_user.role_detail[:default_path] 
        end 

        # send user to 401 page
        return respond_with_unauthorized({ controller: params[:controller], privilege: "grant_#{action}" }) if granted.blank?
        return respond_with_unauthorized({ controller: params[:controller], privilege: "grant_#{action}" }) if not granted["grant_#{action}"] === true

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

    def get_user_agent as_string=false
        user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
        #p "Browser:" + user_agent.browser # Firefox
        #p "Version:" + user_agent.version # 22.0
        #p "Platform:" + user_agent.platform # Macintosh
        #p "Mobile:" + (user_agent.mobile?).to_s # False
        #p "OS:" + user_agent.os # OS X 10.8
        return user_agent
    end

    def get_browser_locale
        accept_language = request.env["HTTP_ACCEPT_LANGUAGE"]
        return unless accept_language
        accept_language.scan(/^[a-z]{2}/).first
    end

end
