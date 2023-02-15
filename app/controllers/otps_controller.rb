=begin

Copyright (c) 2021, all rights reserved.

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

class OtpsController < ApplicationController
    include Interfaces::Application::Responder
    include Interfaces::Application::Requester
    include Interfaces::Application::Logger
    before_action :set_user, only: [:create]

    # PUT /otp
    def update

        # alias for token error message
        error_msg = I18n.t("core.shared.messages_danger_not_valid_authorization_token_found")

        # rebuild the token based on the user-token sent by email
        digest_token = Devise.token_generator.digest(User::AccessCode, :token, params[:t])

        # denied access if can't build the token
        return respond_with_error(error_msg) if digest_token.blank?

        # search for the requested pass
        access_code = User::AccessCode.find_by(token: digest_token, token_type: "otp", last_used_at: nil)

        # denied access if token not found
        if access_code.blank?

            Account::Activity.log("core", "/otp", "otp_session_creation_failed", "not_valid_token_found", {
                token: (params[:t] || "")
            })

            return respond_with_error(error_msg)

        end

        log = access_code.user.logs.create({ title: "session_creation_atempt" })

        # denied access if token do not meet validations
        unless access_code.is_valid?
            log.update(title: "session_creation_failed", description: error_msg)
            return respond_with_error(error_msg) 
        end

        # cache the user from the access code
        resource = access_code.user

        # delete used token
        access_code.update({ last_used_at: Time.current })
        access_code.delete

        # check if user meet requirements to create a new session
        User::ValidationService.new(resource).valid? do |result|

            # if user do not meet requirements to login
            unless result.success?

                log.update(title: "session_creation_failed", description: error_msg)

                # return and respond with the reasons user is not able to login
                return respond_with_error(error_msg) unless result.success?

            end

        end

        # create a new session service instance for the current user 
        session_service = User::SessionService.new(resource, log)

        # register a new session for the user
        current_session = session_service.register(get_user_agent, request.remote_ip, "otp_web_session")

        # make session id globally available
        session[:user_session_id] = current_session[:id]

        # do a user login
        sign_in(access_code.user)

        # respond successful and send the path user should go
        respond_with_successful({ default_path: session_service.default_path() })

    end

    # POST /otps
    def create

        # return if there is no a valid user on set_user
        return respond_with_successful() if @user.blank?

        # create a new otp
        otp = @user.access_codes.new({ token_type: "otp" })

        # generate a user-friendly token
        raw, enc = Devise.token_generator.generate_token(otp.class, :token)

        # save encrypted token in database
        otp.token = enc

        # try to save the access code
        if otp.save

            @user.logs.create({
                title: "otp_creation_successful",
                description: "#{request.remote_ip} | #{get_user_agent}"
            })

            UserMailer.with(user: @user, token: raw).otp_instructions.deliver_now

            respond_with_successful(raw)

        else
            respond_with_error(otp.errors.full_messages.to_sentence)
        end

    end

    private

    def set_user
        @user = User.find_by(email: params[:email], active: true)

        if @user.blank?
            Account::Activity.log("core", "pass", "pass_creation_failed", "no_valid_email", {
                email: (params[:email] || "")
            })
        end
    end

    # Only allow a list of trusted parameters through.
    def otp_params
    end
    
end
