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
    include Application::Responder
    include Application::Logger

    before_action :set_user, only: [:create]

    # GET /otp
    def show

        # we use "t" as alias for token
        redirect_to("/otp/new") and return if params[:t].blank?

        # alias for token error message
        error_msg = I18n.t("core.shared.messages_danger_not_valid_authorization_token_found")

        # rebuild the token based on the user-token sent by email
        digest_token = Devise.token_generator.digest(User::AccessCode, :token, params[:t])

        # denied access if can't build the token
        redirect_to(new_user_session_path, alert: error_msg) and return if digest_token.blank?

        # search for the requested pass
        access_code = User::AccessCode.find_by(token: digest_token, token_type: "otp", last_used_at: nil)

        # denied access if token not found
        if access_code.blank?

            Account::Activity.log("core", "/otp", "otp_session_creation_failed", "not_valid_token_found", {
                token: (params[:t] || "")
            })

            redirect_to(new_user_session_path, alert: error_msg) and return

        end

        # denied access if token do not meet validations
        redirect_to(new_user_session_path, alert: error_msg) and return if !access_code.is_valid?

        # check if user meet requirements to login
        user_validation = UserValidationService.new(access_code.user).valid?

        # if user do not meet requirements to login
        redirect_to(new_user_session_path, alert: error_msg) and return unless user_validation.success?

        # delete used token
        access_code.update({ last_used_at: Time.current })
        access_code.delete


        # IMPORTANT: this is a copy of the main login method at: app/controllers/users/sessions

        # do a user login
        sign_in(access_code.user)

        # register a new unique session
        @current_session = access_code.user.sessions.create({
            :user_agent => get_user_agent,
            :user_remote => request.remote_ip,
            :session_token => session[:session_id],
            :session_source => "otp_session",
            :last_used_at => Time.current
        })

        # make session id globally available
        session[:user_session_id] = @current_session[:id]

        # register a successful sign-in log for the current user
        access_code.user.logs.create({ user_sessions_id: session[:user_session_id], title: "otp_session_creation_successful" })

        # redirect to the root path and return 
        redirect_to("/") and return 

    end

    def new
    end


    # POST /otps
    def create

        # return if there is no a valid user on set_user
        return respond_with_successful() if @user.blank?

        otp = @user.access_codes.new({ token_type: "otp" })

        # generate a user-friendly token
        raw, enc = Devise.token_generator.generate_token(otp.class, :token)

        # save encrypted token in database
        otp.token = enc

        # try to save the access code
        if otp.save

            @user.logs.create({
                title: "otp_creation_successful",
                description: "user_agent: #{get_user_agent}, user_remote: #{request.remote_ip}"
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
