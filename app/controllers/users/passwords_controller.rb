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
class Users::PasswordsController < Devise::PasswordsController
    include Application::Responder
    
    layout "application-public"


    # @controller_action_param :email [String] The registered user email
    # @return [Json] Json with a status response. It contains wheter the email 
    #     with information on how to reset the password was sent or not. 
    #     If it is not successful, it returs an error message
    # @description Sends an email with a token, so the user can reset their password
    # @example
    #     Executing this controller's action from javascript's frontend
    #     let email = 'john.doe@email.com';
    #     let data = {
    #         user: {
    #             email: email
    #         }
    #     };
    #     this.http.post('127.0.0.1/password', data);
    def create
        super do |resource|
            if successfully_sent?(resource)
                #resource.log_activity(request.method, controller_name, action_name, request.original_fullpath, "password_new_requested, " + get_client_info(true))
                return respond_with_successful
            else
                return respond_with_error(I18n.t('deutscheleibrenten.users/passwords.error_invalid_email'))
            end
        end
    end


    # @controller_action_param :password [String] The new password
    # @controller_action_param :password_confirmation [String] The password confirmation
    # @controller_action_param :reset_password_token [String] The token sent by this controller's *create* method
    # @return [Json] Json with a status response. It contains wheter the password was reset or not. 
    #     If it is not successful, it returs an error message
    # @description When the sends their new password along with the token sent by the *create* method,
    #     They can reset their password.
    # @example
    #     Executing this controller's action from javascript's frontend
    #     let data = {
    #         user: {
    #             password: "my_new_password123",
    #             password_confirmation: "my_new_password123",
    #             reset_password_token: "123AWDq23WWer!@$23asd234sdfEaee5447"
    #         }
    #     };
    #     this.http.put('127.0.0.1/password', data);
    def update
        super do |resource|

            log = resource.logs.create({ session_uuid: nil, description: "password_update_atempt" })

            if resource.errors.empty?

                # reset password expiration due the user just updated his password
                if resource.is_password_expired?
                    resource.update_attributes(password_expiration_at: nil)
                end 

                log.update_attribute(:description, "password_update_successful")
                
                return respond_with_successful

            else

                log.update_attribute(:description, "password_update_error")

                return respond_with_error(resource.errors.full_messages.to_sentence)

            end

        end
    end
end
