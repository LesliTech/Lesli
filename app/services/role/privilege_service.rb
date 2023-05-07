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

class Role::PrivilegeService

    def synchronize_privileges role_id = nil
        return
        # bulk all the descriptor privileges
        # this script was built manually for performance
        # basically what it does is get the controllers and actions
        # assigned to a descriptor through the descriptor_privileges table
        records = Descriptor.joins("
            INNER JOIN descriptor_privileges
            ON descriptor_privileges.deleted_at IS NULL 
            AND descriptor_privileges.descriptors_id = descriptors.id 
        ").joins("
            INNER JOIN role_descriptors 
            ON role_descriptors.descriptors_id = descriptors.id
        ").joins("
            INNER JOIN system_controller_actions 
            ON system_controller_actions.id = descriptor_privileges.system_controller_actions_id 
        ").joins("
            INNER JOIN system_controllers 
            ON system_controllers.id = system_controller_actions.system_controllers_id 
        ").select(
            "system_controllers.name as controller", 
            "system_controller_actions.name as action", 
            "role_descriptors.roles_id as roles_id" 
        ).with_deleted

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
