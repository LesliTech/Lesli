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
