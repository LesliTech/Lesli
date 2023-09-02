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
    factory :user, class: "User" do
        
        email { Faker::Internet.email }
        password { Devise.friendly_token }
        salutation { ["mr", "mrs", "ms"][rand(2)] }
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        telephone { Faker::PhoneNumber.phone_number }
        active { true }
        detail_attributes do
            {
                title: Faker::Job.title,
                address: Faker::Address.full_address
            }
        end

        # an account is required
        account_id { (Account.first.nil? ? FactoryBot.create(:account) : Account.first).id }
        # TODO: we should be able to specify if we want create a new account 
        # trait :with_account do
        #     account { (Account.first.nil? ? FactoryBot.create(:account) : Account.first) }
        # end

        # these transient will be available in callbacks as evaluator.<YOUR_TRANSIENT_ATTR>
        transient do
            confirm { true }
        end

        transient do
            role_name { "sysadmin" }
        end

        # callbacks
        before(:create) { |user, evaluator| user.confirm if evaluator.confirm }
        after(:create) do |user, evaluator|
            user.account.user = user
            user.account.save
            user.user_roles.create({ role: Role.find_by(:name => evaluator.role_name) })
        end
    end
end
