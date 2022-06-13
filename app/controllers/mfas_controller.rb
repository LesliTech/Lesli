=begin

Copyright (c) 2022, all rights reserved.

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


class MfasController < ApplicationController
    include Application::Responder
    include Application::Logger

    before_action :set_user, only: [:verify]

    # GET /mfa
    def show

        # we use "t" as alias for token
        redirect_to("/mfa/new") and return if params[:t].blank?

        # alias for token error message
        error_msg = I18n.t("core.shared.messages_danger_not_valid_authorization_token_found")


        mfa_token_verification = AccessCodeService.verify_access_code(mfa_params[:t], "mfa")

        if mfa_token_verification.success?
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
        else
            return respond_with_error(mfa_token_verification.error)
        end
    end

    def new
    end

    def verify
        LC::Debug.deprecation(params)
        # alias for token error message
        error_msg = I18n.t("core.shared.messages_danger_not_valid_authorization_token_found")

        decrypted_email = MfaService.decrypt_key(params[:key])

        user = User.find_for_database_authentication(:email => decrypted_email.payload, :active => true)

        return respond_with_error(I18n.t("core.users/sessions.invalid_credentials")) if user.nil?

        mfa_token_verification = AccessCodeService.verify_access_code(params[:t], "mfa", user)

        if mfa_token_verification.success?
            # IMPORTANT: this is a copy of the main login method at: app/controllers/users/sessions

            # do a user login
            sign_in(user)

            # register a new unique session
            @current_session = user.sessions.create({
                :user_agent => get_user_agent,
                :user_remote => request.remote_ip,
                :session_token => session[:session_id],
                :session_source => "mfa_session",
                :last_used_at => Time.current
            })

            # make session id globally available
            session[:user_session_id] = @current_session[:id]

            # register a successful sign-in log for the current user
            user.logs.create({ user_sessions_id: session[:user_session_id], title: "mfa_session_creation_successful" })

            # redirect to the root path and return 
            return respond_with_successful({ default_path: "/" })
        else
            return respond_with_error(mfa_token_verification.error)
        end
    end

    private

    def set_user
        @user = User.find_by(email: mfa_params[:email], active: true)

        if @user.nil?
            Account::Activity.log("core", "mfa", "mfa_failed", "no_valid_email", {
                email: (params[:email] || "")
            })
        end
    end

    # Only allow a list of trusted parameters through.
    def mfa_params
        params.require(:mfa).permit(
            :t # the MFA token
        )
    end
end
