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
class User::Code < ApplicationLesliRecord

    before_create :generate_token

    belongs_to :user, foreign_key: "users_id", class_name: "::User"

    validates :user, :presence => true

    enum token_type: { pass: "pass", otp: "otp", mfa: "mfa" }

    MIN_TOKEN_DURATION = 4 * 60


    # @return [Integer]
    # @description generates an access code for the associated user
    def generate_token

        # set an expiration time
        self.expiration_at = Time.now.utc + MIN_TOKEN_DURATION

    end


    # @return [Boolean]
    # @description Check if token meets requirements to be used as authentication method
    def is_valid?

        if !self.last_used_at.blank? 

            self.user.logs.create({ 
                title: "pass_session_creation_failed", 
                description: "token_used_already" 
            })

            return false

        end

        if self.expiration_at < Time.now.utc

            self.user.logs.create({ 
                title: "pass_session_creation_failed", 
                description: "token_expired" 
            })

            self.delete

            return false

        end

        return true

    end
end
