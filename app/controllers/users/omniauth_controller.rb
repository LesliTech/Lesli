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
class Users::OmniauthController < Devise::OmniauthCallbacksController

    def google_oauth2

        auth_params = request.env['omniauth.auth']

        user = User.omniauth_registration(auth_params)

        if user.persisted?
            respond_with_successful()
        else
            respond_with_error(user.errors.full_messages.to_sentence)
        end

    end

    def failure
        redirect_to "/dashboard"
    end

end
