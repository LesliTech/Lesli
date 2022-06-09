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

class Users::SessionsController < Devise::SessionsController
    before_action :find_user, only: [:create]

    # @controller_action_param :email [String] The registeredemail
    # @controller_action_param :password [String] The associated password
    # @return [Json] Json that contains wheter the user was successfully signed in or not. 
    #     If it is not successful, it returs an error message
    # @description Creates a new session for the user and allows them access to the platform
    # @example
    #     # Executing this controller"s action from javascript"s frontend
    #     let data = {
    #         user: {
    #             email: "john.doe@email.com",
    #             password: "my_password_1234567890"
    #         }
    #     };
    #     this.http.post("127.0.0.1/login", data);
    def create

        # check password validation
        unless resource.valid_password?(sign_in_params[:password])

            # save a invalid credentials log for the requested user
            resource.logs.create({
                title: "session_creation_failed",
                description: "invalid_credentials"
            })

            # respond with a no valid credentials generic error if not valid user found
            return respond_with_error(I18n.t("core.users/sessions.invalid_credentials"))

        end

        # check if user meet requirements to login
        user_validation = UserValidationService.new(resource).valid?

        # if user do not meet requirements to login
        unless user_validation.success?
            return respond_with_error(user_validation.error["message"])
        end

        # Check if the user has MFA enabled and any valid method configured
        user_mfa = MfaService.new(resource)

        if user_mfa.has_mfa_enabled?.success?
            method = resource.mfa_method

            case method
            when User.mfa_methods[:email] # Enum: E-mail
                code_sent = user_mfa.send_otp_via_email(request)

                return respond_with_error("Something went wrong :( send via otp") unless code_sent.success?
            else
                return respond_with_error("Something went wrong :(")
            end

            # Encrypt the email to send it in the request as a query, like ?key=THE_ENCRYPTED_EMAIL
            encrypted_email = EncryptorService.new_encrytor.encrypt_and_sign(resource.email)

            return respond_with_successful({ default_path: "/mfa/enter_code?key=#{encrypted_email.to_s}" }) # "key" is the encrypted email
        end

        # do a user login
        sign_in(:user, resource)

        # register or sync the current_user with the user representation on Firebase
        Courier::One::Firebase::User.sync_user(resource) if defined? CloudOne

        # register a new unique session
        current_session = resource.sessions.create({
            :user_agent => get_user_agent,
            :user_remote => request.remote_ip,
            :session_source => "devise_standar_session",
            :last_used_at => LC::Date.now
        })

        # make session id globally available
        session[:user_session_id] = current_session[:id]

        # register a successful sign-in log for the current user
        resource.logs.create({ user_sessions_id: session[:user_session_id], title: "session_creation_successful" })

        # get default path of role (if role has default path)
        default_path = resource.roles.first.default_path

        # if first loggin for account owner send him to the onboarding page
        if current_user.account.onboarding? && current_user.has_roles?("owner")
            default_path = "/onboarding"
        end

        # respond successful and send the path user should go
        respond_with_successful({ default_path: default_path })

        # send a welcome email to user if first log in
        UserMailer.with(user: resource).welcome.deliver_later if resource.sign_in_count == 1

    end

    def destroy

        # expire session
        current_session = current_user.sessions.find_by(id: session[:user_session_id])
        if current_session
            current_session.delete
        end

        # register a successful logout log for the current user
        current_user.logs.create({ user_sessions_id: session[:user_session_id], title: "session_logout_successful" })

        # do a user logout
        sign_out current_user

        # Flag to disable back button in browser after Logout using JavaScript
        flash[:logout] = true

        # execute logout callback defined on devise config files
        respond_to_on_destroy

    end

    def enter_code
    end

    private 

    def find_user
        # search for a existing user 

        if sign_in_params[:email]
            self.resource = User.find_for_database_authentication(email: sign_in_params[:email], active: true)            
        elsif params[:key] && sign_in_mfa_params[:mfa_code]
            key = MfaService.parse_key(params[:key])

            decrypted_email = EncryptorService.new_encrytor.decrypt_and_verify(key.payload)

            self.resource = User.find_for_database_authentication(email: decrypted_email, active: true)

            verify_mfa_token(sign_in_mfa_params[:mfa_code]) unless resource.nil?
        end

        unless resource
            Account::Activity.log("core", "/session/create", "session_creation_failed", "no_valid_email", {
                email: (sign_in_params[:email] || "")
            }) 
            return respond_with_error(I18n.t("core.users/sessions.invalid_credentials"))
        end
    end

    def verify_mfa_token(token)
        access_code = AccessCodeService.verify_access_code(token, "otp", resource)

        # Check if something wrong occurred during the token's verification
        if !access_code.successful?
            return respond_with_error(I18n.t("core.shared.messages_danger_not_valid_authorization_token_found"))
        end

        # Assign to the access_code found if everything was successful
        access_code = access_code.payload
     
        # Delete used token
        access_code.update({ last_used_at: Time.current })
        access_code.delete

        # Do a user login
        sign_in(access_code.user)

        # register a new unique session
        current_session = access_code.user.sessions.create({
            :user_agent => get_user_agent,
            :user_remote => request.remote_ip,
            :session_token => session[:session_id],
            :session_source => "otp_session",
            :last_used_at => Time.current
        })

        # Make session id globally available
        session[:user_session_id] = current_session[:id]

        # Register a successful sign-in log for the current user
        access_code.user.logs.create({ user_sessions_id: session[:user_session_id], title: "otp_session_creation_successful" })

        # Respond successful and send the path user should go
        return respond_with_successful({ default_path: "/" })
    end

    # @return [Parameters] Allowed parameters for the discussion
    # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    #     Allowed params are _:email_, _:password_.
    # @example
    #     supose params contains {
    #         "user": {
    #             "id": 5,
    #             "email": "john.smith@email.com",
    #             "password": "my_password_123"
    #         }
    #     }
    #     allowed_params = sign_in_params
    #     puts allowed_params
    #     will remove the _id_ field and only print {
    #         "user": {
    #             "email": "john.smith@email.com",
    #             "password": "my_password_123"
    #         }
    #     }
    def sign_in_params
        params.fetch(:user, {}).permit(:email, :password)
    end

    def sign_in_mfa_params
        params.fetch(:user, {}).permit(:mfa_code)
    end

end
