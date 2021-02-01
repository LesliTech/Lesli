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
    include Application::Responder
    include Application::Logger

    layout "application-public"

    def show

        # get the confirmation token sent through get params
        token = params[:k]

        # validate that token were sent
        if token.blank?
            return flash[:error] = "not a valid token found"
        end

        # check if token belongs to a uncofirmed user
        #user = User.where(:confirmation_token => token).where(:confirmed_at => nil).first
        user = User.find_by(:confirmation_token => token)

        # validate that user were found
        if user.blank?
            return flash[:error] = "not a valid user found"
        end

        # delete all error messages
        flash.discard

        # register a log with a validation atempt for the user
        log = user.logs.create({ session_uuid: nil, description: "confirmation_atempt_successful" })

        # confirm the user
        user.confirm

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
