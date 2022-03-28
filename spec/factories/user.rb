=begin

Copyright (c) 2021, all rights reserved.

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


FactoryBot.define do
    factory :user, class: "User" do
        email { Faker::Internet.email }
        password { Devise.friendly_token }
        active { true }
        detail_attributes do
            {
                salutation: "mr",
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name
            }
        end

        # an account is required
        account { (Account.first.nil? ? FactoryBot.create(:account) : Account.first) }
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
            user.user_roles.create({ role: Role.find_by(:name => evaluator.role_name) })
        end
    end
end
