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
    include Interfaces::Application::Responder
    include Interfaces::Application::Logger
    include Application::Requester

    before_action :set_locale
    before_action :authorize_request
    before_action :authorize_privileges
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




    # ===============================================================
    # Temporal overwrite to keep compatibility
    # ===============================================================

    # Overwrite: Return an standard http 200 respond
    def respond_with_successful payload=nil

        response_body_v2 = {
            successful: true,
            data: payload
        }

        if payload.as_json.instance_of?(Array)
            response_body_v3 = {
                records: payload.as_json
            }
        else
            response_body_v3 = {
                **payload.as_json
            }
        end

        respond_with_http(200, {
            **response_body_v2,
            **response_body_v3,
        })

    end

    # Overwrite: Return an pagination http 200 respond
    def respond_with_pagination(records, payload=nil)

        response_pagination_v2 = {
            :total_pages => records.total_pages,
            :current_page => records.current_page,
            :count_total => records.total_count,
            :count_results => records.length
        }

        response_pagination_v3 = {
            :pages => records.total_pages,
            :page => records.current_page,
            :total => records.total_count,
            :results => records.length
        }

        respond_with_http(200, {
            :pagination => {
                **response_pagination_v2,
                **response_pagination_v3,
            },
            :records => payload || records
        })

    end


    # Overwrite: JSON not found response
    def respond_with_not_found

        response_body_v2 = {
            successful: false,
            error: {
                message: I18n.t("core.shared.messages_danger_not_found"),
                details: []
            }
        }

        response_body_v3 = {
            message: I18n.t("core.shared.messages_danger_not_found")
        }

        respond_with_http(404, {
            **response_body_v2,
            **response_body_v3,
        })
    end


    # Overwrite: JSON not found response
    def respond_with_unauthorized(detail = {})

        response_body_v2 = {
            successful: false,
            error: {
                message: I18n.t("core.shared.view_text_unauthorized_request")
            },
        }

        response_body_v3 = {
            message: I18n.t("core.shared.view_text_unauthorized_request")
        }

        response_body = {
            **response_body_v2,
            **response_body_v3,
        }

        respond_to do |format|
            format.json { render status: 401, json: response_body.to_json }
            format.html { render status: 401, json: response_body.to_json }
            format.xlsx { render status: 401, json: response_body.to_json }
        end

    end

    # Overwrite: JSON failure response
    def respond_with_error message = "", details = []

        # Message should be a String
        message = "" unless message.instance_of?(String)

        response_body_v2 = {
            successful: false,
            error: {
                message: message,
                details: details
            }
        }

        response_body_v3 = {
            message: message,
            details: details
        }

        respond_with_http(400, {
            **response_body_v2,
            **response_body_v3,
        })

    end

end
