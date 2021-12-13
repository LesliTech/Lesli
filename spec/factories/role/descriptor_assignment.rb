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

    factory :role_descriptor_assignment, class: "Role::DescriptorAssignment" do
        category { Faker::Lorem.word }
        roles_id { nil } # this params must be given in the test
        role_descriptors_id { nil } # this params must be given in the test
    end

    factory :invalid_role_descriptor_assignment, class: "Role::DescriptorAssignment" do
        category { nil }
        roles_id { nil }
        role_descriptors_id { nil }
    end

end