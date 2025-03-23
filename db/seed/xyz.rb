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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

def create_account_user email, rolename, firstname, lastname, password

    account = Lesli::Account.find_by(email: Lesli.config.company.dig(:email))

    # create development users if email is not registered yet
    Lesli::User.find_or_create_by(email: email) do |user|
        user.account = account
        user.password = password
        user.password_confirmation = password

        # confirm user through device
        user.confirm unless user.confirmed?

        user.first_name = firstname
        user.last_name = lastname
        user.save!

        user.roles.create!({ role: Lesli::Role.find_by(:name => rolename) })

        user
    end
end
