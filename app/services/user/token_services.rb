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


class User::TokenService < ApplicationLesliServices

    # check if user has enable multi-factor authentication
    # or if the account has enable mfa for all the users
    # NOTE: User also needs to have a MFA method selected
    def is_valid?

    end

    # Generate a MFA code
    def generate(name, source, type:'number', length:8, expiration_at:nil)

        # We use a reusable service that generates access codes
        #access_code = @resource.tokens.new()

        # We generate the raw and the encrypted token
        #raw, enc = Devise.token_generator.create(access_code.class, :token, type:'number', length:6)

        # Set the encrypted token, which will be saved into the DB
        #access_code.update(token: enc)

        raw, enc = Devise.token_generator.create(User::Token, :token, type, length)

        # creates a new token
        @current_user.tokens.create({
            :name => name, 
            :token => enc,
            :source => source, 
            :expiration_at => expiration_at
        })

        raw

    end
end
