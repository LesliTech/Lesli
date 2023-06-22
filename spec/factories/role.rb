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


FactoryBot.define do

    # Valid role creation
    factory :role, class: "Role" do
        name { Faker::Lorem.word }
        active { true }
        object_level_permission { Faker::Number.number(digits: 2) }
        account { Account.first }
    end

    # Invalid role
    factory :role_not_valid, class: "Role" do
        name { nil }
        active { nil }
        object_level_permission { 0 }
        account { Account.first }
    end

    # With default path
    factory :role_with_default_path, class: "Role" do
        name { Faker::Lorem.word }
        active { true }
        default_path { "/administration/account" }
        limit_to_path { true }
        object_level_permission { Faker::Number.number(digits: 2) }
        account { Account.first }
    end

end
