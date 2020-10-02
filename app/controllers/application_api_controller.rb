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
    after_action  :log_user_requests

    @current_user = nil
    @current_session = nil

    
    protected


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


    # Track all user activity
    # this is disabled by default in the settings file
    def log_user_comments description=nil

        return if !Rails.application.config.lesli_settings["configuration"]["security"]["log_activity"]

        return if @current_user.blank?

        @current_user.logs.create({
            session_uuid: @current_session[:session_uuid],
            description: description
        })

    end


    # Track all user activity
    # this is disabled by default in the settings file
    def log_user_requests

        return if !Rails.application.config.lesli_settings["configuration"]["security"]["log_activity"]

        return if @current_user.blank?
        return if @current_session.blank?

        @current_user.requests.create({
            user_sessions_id: @current_session[:id],
            request_agent: get_user_agent,
            request_controller: controller_path,
            request_method: request.method,
            request_action: action_name, 
            request_url: request.original_fullpath, 
            params: request.filtered_parameters.except(:controller, :action) # request.params.except(:controller, :action, :password)
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


    def get_user_agent
        user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
        #p "Browser:" + user_agent.browser # Firefox
        #p "Version:" + user_agent.version # 22.0
        #p "Platform:" + user_agent.platform # Macintosh
        #p "Mobile:" + (user_agent.mobile?).to_s # False
        #p "OS:" + user_agent.os # OS X 10.8
        return "#{user_agent.platform} #{user_agent.os} - #{user_agent.browser} #{user_agent.version}"
    end


    private


    # Set default query params for:
    #   pagination
    #   sorting
    #   filtering
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


    # Validate if user authentication and session status
    def authorize_request

        @current_session = nil

        # Try to find a valid session using a token
        (-> () { 

            token = nil

            # check headers for Authorization Bearer token
            if request.headers["Authorization"].present?
                token = request.headers["Authorization"].split("Bearer ").last
            end

            # Query opaque token takes precedence over the authorization header
            if not params[:access_token].blank?
                token = params[:access_token]
            end            

            # return without session if token was not provided
            return if not token

            # check if token is a valid JWT
            jwt = LC::System::Jwt.decode(token)

            if jwt.successful?
                @current_session = User::Session.find_by(
                    :user_uuid => jwt.payload[0]["sub"],
                    :session_uuid => jwt.payload[0]["jti"]
                )
                return 
            end

            # check if token is a valid opaque integration token
            @current_session = User::Session.find_by(
                :session_token => token
            )

        }).call()


        if @current_session.blank?
            return respond_with_unauthorized "Not valid authorization token found"
        end

        @current_user = @current_session.user

        if @current_user.blank?
            return respond_with_unauthorized "Not valid authorization token found"
        end

    end

end
