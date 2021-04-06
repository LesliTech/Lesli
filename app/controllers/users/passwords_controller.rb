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

        if params[:user].blank?
            Account::Activity.log("core", "/password/create", "password_creation_failed", "no_valid_email") 
            return respond_with_error("valid_user_not_found")
        end

        if params[:user][:email].blank?
            Account::Activity.log("core", "/password/create", "password_creation_failed", "no_valid_email") 
            return respond_with_error("valid_user_not_found")
        end

        user = User.find_by(:email => params[:user][:email])

        if user.blank?
            Account::Activity.log("core", "/password/create", "password_creation_failed", "no_valid_email", {
                email: (params[:user][:email] || "")
            }) 
            return respond_with_error("valid_user_not_found")
        end

        if not user.active
            user.logs.create({title: "password_creation_failed", description: "user_not_active"})
            Account::Activity.log("core", "/password/create", "password_creation_failed", "user_not_active") 
            return respond_with_error(I18n.t("core.users/passwords.messages_danger_inactive_user"))
        end

        token = user.generate_password_reset_token

        user.logs.create({ title: "password_creation_successful" })

        begin
            UserMailer.with(user: user, token: token).reset_password_instructions.deliver_now
            respond_with_successful
        rescue => exception
            Honeybadger.notify(exception)
            respond_with_error(exception.message)
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

            if resource.errors.empty?

                # reset password expiration due the user just updated his password
                if resource.has_expired_password?
                    resource.update(password_expiration_at: nil)
                end 

                resource.logs.create(description: "password_reset_successful")
                
                return respond_with_successful

            else

                resource.logs.create(description: "password_reset_error") if resource.id

                return respond_with_error(resource.errors.full_messages.to_sentence)

            end

        end
    end

end
