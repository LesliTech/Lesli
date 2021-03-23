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
    include ActionController::MimeResponds

    include Application::Responder
    include Application::Requester
    include Application::Logger

    before_action :set_locale
    before_action :authorize_request
    before_action :authorize_privileges
    before_action :set_request_helpers
    before_action :set_helpers_for_request
    after_action  :log_user_requests

    @current_user = nil
    @current_session = nil


    private
 

    # Check if current_user has privileges to complete this request
    # allowed core methods:
    #   [:index, :create, :update, :destroy, :new, :show, :edit, :options, :search, :resources]
    def authorize_privileges

        return true

    end


    # Validate user authentication and session status
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
            # TODO: Add validation to allow only specific token sources
            @current_session = User::Session.find_by(
                :session_token => token
            )

        }).call()


        if @current_session.blank?
            return respond_with_unauthorized "Not valid authorization token found"
        end

        if @current_session.expiration_at && @current_session.expiration_at <= LC::Date.now
            return respond_with_unauthorized "Authorization token already expired"
        end

        @current_user = @current_session.user

        if @current_user.blank?
            return respond_with_unauthorized "Not valid authorization token found"
        end

        if @current_user.has_expired_password?
            return respond_with_unauthorized "Password already expired"
        end

    end

end
