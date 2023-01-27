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

        # save a invalid credentials log for the requested user
        log = resource.logs.new({ title: "session_creation_atempt" })

        # check password validation
        unless resource.valid_password?(sign_in_params[:password])

            # save a invalid credentials log for the requested user
            log.update({
                title: "session_creation_failed",
                description: "invalid_credentials"
            })

            # respond with a no valid credentials generic error if not valid user found
            return respond_with_error(I18n.t("core.users/sessions.invalid_credentials"))

        end

        # check if user meet requirements to create a new session
        Auth::UserValidationService.new(resource).valid? do |result|

            # if user do not meet requirements to login
            unless result.success?

                log.update({
                    title: "session_creation_failed",
                    description: result.error["message"]
                })

                # return and respond with the reasons user is not able to login
                return respond_with_error(result.error["message"]) unless result.success?

            end

        end

        # remember the user (not enabled by default)
        # remember_me(user) if sign_in_params[:remember_me] == '1'

        # create a new session service instance for the current user 
        session_service = Auth::UserSessionService.new(resource, log)

        # register a new session for the user
        current_session = session_service.register(get_user_agent, request.remote_ip)

        # make session id globally available
        session[:user_session_id] = current_session[:id]

        # create a new multi factor authentication service instance for the current user 
        mfa_service = Auth::UserMfaService.new(resource, log)

        # generate a new mfa for the current session (if enabled)
        mfa_service.generate do |success|

            # mfa was successfully generated, return the user to the mfa page
            return respond_with_successful({ default_path: "mfa" }) if success

        end 

        # do a user login
        sign_in(:user, resource)

        # respond successful and send the path user should go
        respond_with_successful({ default_path: session_service.default_path() })

        log_user_agent()

    end

    def destroy

        # get the current session
        current_session = current_user.sessions.find_by(id: session[:user_session_id])
        
        # expire the current session 
        current_session.delete if current_session

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
