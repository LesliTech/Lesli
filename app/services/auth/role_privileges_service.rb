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
            records = Descriptor.joins(:privileges, :describers_all).with_deleted.select(
                "descriptor_privileges.controller",
                "descriptor_privileges.action",
                "descriptor_privileges.form",
                "role_describers.deleted_at",
                "role_describers.roles_id"
            )

            # synchronize only for the given role, this is needed to sync only modified roles
            records = records.where("role_describers.roles_id" => role_id) if role_id

            # convert the results to json so it is easy to insert/update
            records = records.as_json(only: [:controller, :action, :form, :roles_id, :deleted_at])

            
            # IMPORTANT: We must save only uniq privileges in the role_privilege table
            # this means that it does not matters how many times we defined a privilege dependency
            # we insert the privilege only once.
            # Example: If we defined that we need access to UsersController#index in 20 descriptors,
            # in the role_privileges will be only one record for that specific controller and action
            records = records.uniq

            # small check to ensure I have records to update/insert
            return if records.blank?

            # bulk update/insert into role privilege cache table
            Role::Privilege.with_deleted.upsert_all(records, unique_by: [:controller, :action, :form, :roles_id])

        end 

    end
end
