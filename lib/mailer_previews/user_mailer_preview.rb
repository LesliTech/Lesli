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

class UserMailerPreview < ActionMailer::Preview

    def welcome
        UserMailer.with(user: User.first).welcome
    end

    def first_access
        UserMailer.with(user: User.first, token: "my_token").first_access
    end

    def invitation_instructions
        UserMailer.with(user: User.first).invitation_instructions
    end

    def reset_password_instructions
        UserMailer.with(
            user: User.first, 
            token: "my_reset_password_token"
        ).reset_password_instructions
    end

    def pass_instructions
        UserMailer.with(user: User.first, token: "my_token").pass_instructions
    end

    def otp_instructions
        UserMailer.with(user: User.first, token: "my_token").otp_instructions
    end

    def mfa_instructions
        UserMailer.with(user: User.first, token: "012345").mfa_instructions
    end

end
