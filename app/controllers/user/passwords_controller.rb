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

class User::PasswordsController < ApplicationLesliController

    # GET /user/passwords/1/edit
    def edit
    end

    # POST /user/passwords
    def create
    end

    # PATCH/PUT /user/passwords/1
    def update

        @user = current_user

        log = @user.logs.create({ description: "password_update_atempt" })

        if @user.update(user_password_params)

            # reset password expiration due the user just updated his password
            if @user.is_password_expired?
                @user.update(password_expiration_at: nil)
            end 

            # Sign in the user by passing validation in case their password changed
            bypass_sign_in(@user)

            respond_with_successful

            log.update(description: "password_update_successful")

        else

            respond_with_error(@user.errors.full_messages.to_sentence)

            log.update(description: "password_update_error")

        end
        
    end

    private

    # Only allow a trusted parameter "white list" through.
    def user_password_params
        params.require(:user).permit(:email, :password, :password_confirmation, :password_expiration_at)
    end
    
end
