# frozen_string_literal: true
class Users::ConfirmationsController < Devise::ConfirmationsController

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
        user = Lesli::User.find_by(:confirmation_token => token, :confirmed_at => nil)

        # validate that user were found
        if user.blank?
            return flash[:danger] = I18n.t("core.users/confirmations.messages_warning_invalid_token")
        end

        # register a log with a validation atempt for the user
        log = user.logs.create({ description: "confirmation_atempt_successful" })

        registration_operator = Lesli::UserRegistrationOperator.new(user)

        # confirm the user
        registration_operator.confirm

        # let the user knows that the confirmation is done
        flash[:success] = I18n.t("core.users/confirmations.messages_success_email_updated")
        
        # if new account, launch account onboarding in another thread, 
        # so the user can continue with the registration process
        registration_operator.create_account if user.account.blank?
        #Thread.new { registration_operator.create_account } if user.account.blank?

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
