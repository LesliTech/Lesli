=begin
Copyright (c) 2023, all rights reserved.

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
class Role::Descriptor < ApplicationLesliRecord
    belongs_to :role, foreign_key: "roles_id", class_name: "::Role"
    belongs_to :descriptor, foreign_key: "descriptors_id", class_name: "::Descriptor"

    after_save :synchronize_privileges

    def synchronize_privileges
        # Syncronize the descriptor privileges with the role privilege cache table 
        Auth::RolePrivilegesService.new.synchronize_privileges(self.roles_id)
    end 

end
