=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end
class Users::PasswordsController < Devise::PasswordsController
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
            return respond_with_error(I18n.t("core.shared.messages_warning_user_not_found"))
        end

        if params[:user][:email].blank?
            Account::Activity.log("core", "/password/create", "password_creation_failed", "no_valid_email")
            return respond_with_error(I18n.t("core.shared.messages_warning_user_not_found"))
        end

        user = User.find_by(:email => params[:user][:email])

        if user.blank?
            Account::Activity.log("core", "/password/create", "password_creation_failed", "no_valid_email", {
                email: (params[:user][:email] || "")
            })
            return respond_with_error(I18n.t("core.shared.messages_warning_user_not_found"))
        end

        unless user.active
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
            respond_with_error("Error sending password recovery email")
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

            # check if password update was ok
            if resource.errors.empty?

                # reset password expiration due the user just updated his password
                if resource.has_expired_password?
                    resource.update(password_expiration_at: nil)
                end

                resource.logs.create(title: "password_reset_successful")

                return respond_with_successful

            else

                resource.logs.create(title: "password_reset_error") if resource.id

                return respond_with_error(resource.errors.full_messages.to_sentence)

            end

        end
    end

end
