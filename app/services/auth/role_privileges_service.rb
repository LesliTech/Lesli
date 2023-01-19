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

module Auth

    class RolePrivilegesService

        def initialize()
        end

        def synchronize_privileges role_id = nil

            # bulk all the descriptor privileges
            records = Descriptor.joins(:privileges, :role_descriptors_all).with_deleted.select(
                "descriptor_privileges.controller",
                "descriptor_privileges.action",
                "role_descriptors.roles_id"
            )

            # synchronize only for the given role, this is needed to sync only modified roles
            records = records.where("role_descriptors.roles_id" => role_id) if role_id

            # convert the results to json so it is easy to insert/update
            records = records.as_json(only: [:controller, :action, :roles_id])

            # small check to ensure I have records to update/insert
            return if records.blank?

            # bulk update/insert into role privilege cache table
            Role::Privilege.with_deleted.upsert_all(records, unique_by: [:controller, :action, :roles_id])

        end 

    end
end
