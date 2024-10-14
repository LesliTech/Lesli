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


# ·
FactoryBot.define do
    factory :lesli_user, class: "Lesli::User" do
        
        active      { true }
        email       { Faker::Internet.email }
        salutation  { ["mr", "mrs", "ms"][rand(2)] }
        first_name  { Faker::Name.first_name }
        last_name   { Faker::Name.last_name }
        telephone   { Faker::PhoneNumber.phone_number }

        password { Devise.friendly_token }

        account_id { (Lesli::Account.first.nil? ? FactoryBot.create(:lesli_account) : Lesli::Account.first).id }


        transient do
            role_name { "owner" } 
        end

        before(:create) do |user, evaluator|
            user.skip_confirmation!
        end

        after(:create) do |user, evaluator|
            user.confirm { true }
            user.powers.create(role: Lesli::Role.find_by(:name => evaluator.role_name))
        end
        
    end
end
