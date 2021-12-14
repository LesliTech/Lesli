=begin

Copyright (c) 2020, all rights reserved.

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
    # valid model
    factory :role_descriptor, class: "RoleDescriptor" do
        name { Faker::Lorem.word }
        description { Faker::Lorem.paragraph }
        account { association :account }
    end

    # nil params
    factory :invalid_r_d, class: "RoleDescriptor" do
        name { nil }
        description { nil }
        association :account
    end

    # empty string params
    factory :empty_str_r_d, class: "RoleDescriptor" do
        name { "" }
        description { "" }
        association :account
    end
end