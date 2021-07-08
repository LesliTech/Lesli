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
class Role::DescriptorAssignment < ApplicationLesliRecord
    belongs_to :role,               foreign_key: "roles_id",             class_name: "::Role"
    belongs_to :descriptor,         foreign_key: "role_descriptors_id",  class_name: "::RoleDescriptor"
    
    has_many   :privilege_actions,  through: :descriptor
    
    def self.index(current_user, role, query)
        
    end
end
