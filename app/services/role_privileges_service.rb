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

class RolePrivilegesService

    def initialize()
    end

    def synchronize_privileges

        # bulk all the descriptor privileges
        records = Descriptor.joins(:privileges, :describers).select(
            "descriptor_privileges.active",
            "descriptor_privileges.controller",
            "descriptor_privileges.action",
            "role_describers.roles_id"
        ).as_json(only: [:active, :controller, :action, :roles_id])

        # small check to ensure I have records to update/insert
        return if records.blank?

        # bulk update/insert into role privilege cache table
        Role::Privilege.upsert_all(
            records,
            unique_by: [:controller, :action, :roles_id]
        )

    end 

end
