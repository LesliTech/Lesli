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


FactoryBot.define do
    factory :account, class: "Lesli::Account" do
        #status { Account.statuses.keys.first }
        company_name { Faker::Company.name }
        company_name_legal { Faker::Company.name }
        company_tagline { Faker::Company.bs }
        # country { Faker::Address.country }
        address { Faker::Address.full_address }
        #region { Account.regions.values.sample }
        #city { Faker::Address.city }
        postal_code { Faker::Address.zip_code }
        website { Faker::Internet.url  }
        phone_number_1 { Faker::PhoneNumber.phone_number }
        public_email { Faker::Internet.email }
        github { Faker::Lorem.word }
        twitter { Faker::Twitter.user[:name] }
        youtube { Faker::Lorem.word }
        linkedin { Faker::Lorem.word }
        facebook { Faker::Lorem.word }

        after(:create) do |account, evaluator|
            account.user = FactoryBot.create(:user, account_id: account.id)
            account.save
        end
    end
end
