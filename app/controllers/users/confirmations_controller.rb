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

class Users::ConfirmationsController < Devise::ConfirmationsController
    layout "application-public"

    def show

        # delete all previus messages
        flash.clear

        # get the confirmation token sent through get params
        token = params[:confirmation_token]

        # validate that token were sent
        if token.blank?
            return flash[:danger] = I18n.t("core.users/confirmations.messages_warning_invalid_token")
        end

        # check if token belongs to a unconfirmed user
        user = User.find_by(:confirmation_token => token, :confirmed_at => nil)

        # validate that user were found
        if user.blank?
            return flash[:danger] = I18n.t("core.users/confirmations.messages_warning_invalid_token")
        end

        # register a log with a validation atempt for the user
        log = user.logs.create({ description: "confirmation_atempt_successful" })

        registration_service = User::RegistrationService.new(user)

        # confirm the user
        registration_service.confirm

        # let the user knows that the confirmation is done
        flash[:success] = I18n.t("core.users/confirmations.messages_success_email_updated")
        
        # if new account, launch account onboarding in another thread, 
        # so the user can continue with the registration process
        Thread.new { registration_service.create_account } if user.account.blank?

    end

    
    # @controller_action_param :email [String] The registered user email
    # @return [Json] Json that contains wheter the email confirmation was sent or not. 
    #     If it is not successful, it returs an error message
    # @description Resends a email confirmation an already registered user
    # @example
    #     # Executing this controller's action from javascript's frontend
    #     let email = 'john.doe@email.com';
    #     let data = {
    #         user: {
    #             email: email
    #         }
    #     };
    #     this.http.post('127.0.0.1/conformation', data);
    def create
        super do |resource|
            if successfully_sent?(resource)
                return respond_with_successful
            else
                return respond_with_error(resource.errors.full_messages.to_sentence)
            end
        end
    end

end
