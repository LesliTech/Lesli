=begin
Copyright (c) 2022, all rights reserved.

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
class Role::Describer < ApplicationLesliRecord
    belongs_to :role,       foreign_key: "roles_id"
    belongs_to :descriptor, foreign_key: "descriptors_id"

    after_commit :synchronize_privileges, on: [:create, :update]

    private

    def synchronize_privileges
        records = self.descriptor.privileges
        .select(:active, :controller, :action)
        .as_json(only: [:active, :controller, :action])

        self.role.privileges.upsert_all(
            records,
            unique_by: [:controller, :action]
        )
    end 

end
