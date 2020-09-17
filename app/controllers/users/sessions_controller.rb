=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description Manages session login for existing users

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class Users::SessionsController < Devise::SessionsController
    layout "application-public"

    # @controller_action_param :email [String] The registeredemail
    # @controller_action_param :password [String] The associated password
    # @return [Json] Json that contains wheter the user was successfully signed in or not. 
    #     If it is not successful, it returs an error message
    # @description Creates a new session for the user and allows them access to the platform
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let data = {
    #         user: {
    #             email: 'john.doe@email.com',
    #             password: 'my_password_1234567890'
    #         }
    #     };
    #     this.http.post('127.0.0.1/login', data);
    def create

        # search for a existing user 
        resource = User.find_for_database_authentication(email: sign_in_params[:email], active: true)

        return respond_with_error(I18n.t('deutscheleibrenten.users/sessions.invalid_credentials')) unless resource

        activity = resource.log_activity(request.method, controller_name, action_name, request.original_fullpath, "login_atempt")

        unless resource.valid_password?(sign_in_params[:password])
            activity.update_attribute(:description, "login_atempt_invalid_credentials, " + get_client_info(true))
            return respond_with_error(I18n.t('deutscheleibrenten.users/sessions.invalid_credentials'))
        end
        
        unless resource.confirmed?
            return respond_with_error(I18n.t("devise.errors.custom.confirmation_required, " + get_client_info(true)))
        end

        return respond_with_error(I18n.t('deutscheleibrenten.users/sessions.role_access_denied')) unless resource.role.detail.active?

        sign_in :user, resource

        activity.update_attribute(:description, "login_atempt_successful, " + get_client_info(true))

        respond_with_successful()

    end

    def destroy
        current_user.log_activity(request.method, controller_name, action_name, request.original_fullpath, "logout, " + get_client_info(true))
        sign_out current_user
        flash[:logout] = true # Flag to disable back button in browser after Logout using JavaScript
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
