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

        # search for a existing user 
        resource = User.find_for_database_authentication(email: sign_in_params[:email], active: true)

        # respond with a no valid credentials generic error if not valid user found
        unless resource
            Account::Activity.log("core", "/session/create", "session_creation_failed", "no_valid_email", {
                email: (sign_in_params[:email] || "")
            }) 
            return respond_with_error(I18n.t("core.users/sessions.invalid_credentials"))
        end

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

        # Create an instance used to validate MFA for the user
        user_mfa = MfaService.new(resource)

        # Check if the user has MFA enabled and any valid method configured
        if user_mfa.has_mfa_enabled?.success?

            mfa_token = user_mfa.do_mfa()

            return respond_with_error(mfa_token.error) unless mfa_token.success?

            # Create logs that an MFA Token was created successfully
            resource.logs.create({
                title: "mfa_token_creation_successful",
                description: "user_agent: #{request.user_agent}, user_remote: #{request.remote_ip}"
            })

            # We prepared the default path redirection
            encrypted_email = CGI.escape(EncryptorService.new_encrytor.encrypt_and_sign(resource.email))

            return respond_with_successful({ default_path: "/mfa/new?key=#{encrypted_email}" })
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


    private 


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

end
