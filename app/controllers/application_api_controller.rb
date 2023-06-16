=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

class ApplicationApiController < ActionController::API
    include ActionController::MimeResponds
    include Interfaces::Application::Responder
    include Interfaces::Application::Requester
    include Interfaces::Application::Logger

    before_action :set_locale_public
    before_action :authorize_request
    before_action :authorize_privileges
    before_action :set_helpers_for_request
    after_action  :log_user_requests

    @current_user = nil
    @current_session = nil

    protected

    attr_reader :query
    attr_reader :current_user
    attr_reader :current_session

    # Rescue from "ParameterMissing" when using required params in controllers
    rescue_from ActionController::ParameterMissing do |e|
        respond_with_error("Missing params")
    end

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
            unless params[:access_token].blank?
                token = params[:access_token]
            end

            # return without session if token was not provided
            return unless token

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
            return respond_with_unauthorized I18n.t("core.shared.messages_danger_not_valid_authorization_token_found")
        end

        if @current_session.expiration_at && @current_session.expiration_at <= LC::Date.now
            return respond_with_unauthorized I18n.t("core.shared.messages_danger_authorization_token_already_expired")
        end

        @current_user = @current_session.user

        if @current_user.blank?
            return respond_with_unauthorized I18n.t("core.shared.messages_danger_not_valid_authorization_token_found")
        end

        if @current_user.has_expired_password?
            return respond_with_unauthorized I18n.t("core.shared.messages_danger_password_already_expired")
        end

    end
end
