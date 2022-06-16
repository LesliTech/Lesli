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
    include Interfaces::Application::Responder
    include Application::Logger

    # /mfa/new
    def new
    end

    # /mfa/verify.json
    def verify
        # alias for token error message
        error_msg = I18n.t("core.shared.messages_danger_not_valid_authorization_token_found")

        # Decrypt the key that comes from the URL
        begin
            decrypted_email = EncryptorService.new_encrytor.decrypt_and_verify(params[:key])
        rescue => exception
            return respond_with_error(error_msg)
        end

        # Search an existing user
        user = User.find_for_database_authentication(:email => decrypted_email, :active => true)

        return respond_with_error(error_msg) if user.nil?

        # Check if the user has MFA enabled
        mfa_user_verification = MfaService.new(user).has_mfa_enabled?

        return respond_with_error(error_msg) unless mfa_user_verification.success?

        # Check if we can build the token
        digest_token = Devise.token_generator.digest(User::AccessCode, :token, mfa_params[:t])

        return respond_with_error(error_msg) if digest_token.blank?

        # Find access code for the requested token
        access_code = user.access_codes.find_by(token: digest_token, token_type: "mfa", last_used_at: nil) 

        if access_code.blank?
            Account::Activity.log("core", "/mfa/new", "mfa_token_session_verification_failed", "not_valid_token_found", {
                token: (mfa_params[:t] || "")
            })

            # Return false if the token was not found
            return respond_with_error(error_msg)
        end

        return respond_with_error(error_msg) unless access_code.is_valid?

        # check if user meet requirements to login
        user_validation = UserValidationService.new(user).valid?

        # if user do not meet requirements to login
        return respond_with_error(error_msg) unless user_validation.success?

        # delete used token
        access_code.update({ last_used_at: Time.current })
        access_code.delete

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
    end

    private

    # Only allow a list of trusted parameters through.
    def mfa_params
        params.fetch(:mfa, {}).permit(
            :t # the MFA token
        )
    end
end
