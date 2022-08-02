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

        # check if token belongs to a uncofirmed user
        user = User.find_by(:confirmation_token => token, :confirmed_at => nil)

        # validate that user were found
        if user.blank?
            return flash[:danger] = I18n.t("core.users/confirmations.messages_warning_invalid_token")
        end

        # register a log with a validation atempt for the user
        log = user.logs.create({ description: "confirmation_atempt_successful" })

        # confirm the user
        user.confirm

        # force token deletion so we are sure nobody will be able to use the token again
        user.update(confirmation_token: nil)

        # let the user knows that the confirmation is done
        flash[:success] = I18n.t("core.users/confirmations.messages_success_email_updated")
        
        # if new account, launch account onboarding in another thread, 
        # so the user can continue with the registration process
        Thread.new { UserRegistrationService.new(user).create_account } if user.account.blank?

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
