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

        log = @user.logs.create({ title: "password_update_atempt" })

        if @user.update(user_password_params)

            # reset password expiration due the user just updated his password
            if @user.is_password_expired?
                @user.update(password_expiration_at: nil)
            end 

            # Sign in the user by passing validation in case their password changed
            bypass_sign_in(@user)

            respond_with_successful

            log.update(title: "password_update_successful")

        else

            respond_with_error(@user.errors.full_messages.to_sentence)

            log.update(title: "password_update_error")

        end
        
    end

    private

    # Only allow a trusted parameter "white list" through.
    def user_password_params
        params.require(:user).permit(:email, :password, :password_confirmation, :password_expiration_at)
    end
    
end
