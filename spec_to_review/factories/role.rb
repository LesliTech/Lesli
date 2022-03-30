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

    # Valid role creation
    factory :role, class: "Role" do
        name { Faker::Lorem.word }
        active { true }
        object_level_permission { Faker::Number.number(digits: 4) }
        accounts_id { FactoryBot.create(:account).id }
    end

    # Invalid role
    factory :invalid_role, class: "Role" do
        name { nil }
        active { nil }
        object_level_permission { nil }
        accounts_id { FactoryBot.create(:account) }
    end

end