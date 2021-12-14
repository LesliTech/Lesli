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

    factory :privilege_action, class: "RoleDescriptor::PrivilegeAction" do
        status { true }
        category { "create" }
        system_controller_actions_id { FactoryBot.create(:system_controller_action).id }
        role_descriptors_id { FactoryBot.create(:role_descriptor).id }
    end

    factory :invalid_privilege_action, class: "RoleDescriptor::PrivilegeAction" do
        status { nil }
        category { nil }
        system_controller_actions_id { nil }
        role_descriptors_id { nil }
    end

end