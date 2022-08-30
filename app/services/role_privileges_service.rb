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
            "descriptor_privileges.controller",
            "descriptor_privileges.action",
            "descriptor_privileges.form",
            "role_describers.roles_id"
        ).as_json(only: [:controller, :action, :form, :roles_id])
        
        # IMPORTANT: We must save only uniq privileges in the role_privilege table
        # this means that it does not matters how many times we defined a privilege dependency
        # we insert the privilege only once.
        # Example: If we defined that we need access to UsersController#index in 20 descriptors,
        # in the role_privileges will be only one record for that specific controller and action
        records = records.uniq

        # small check to ensure I have records to update/insert
        return if records.blank?

        # bulk update/insert into role privilege cache table
        Role::Privilege.upsert_all(
            records,
            unique_by: [:controller, :action, :form, :roles_id]
        )

    end 

end
