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
        Role::PrivilegeService.new.synchronize_privileges(self.roles_id)
    end 

    def self.index current_user, query, params
        current_user.account.descriptors
        .joins(sanitize_sql_array(["
                left join role_descriptors 
                on role_descriptors.descriptors_id = descriptors.id 
        "])).select(
            "descriptors.id",
            "descriptors.name",
            "role_descriptors.privilege_index",
            "role_descriptors.privilege_show",
            "role_descriptors.privilege_create",
            "role_descriptors.privilege_update",
            "role_descriptors.privilege_destroy",
            "role_descriptors.id as role_descriptor_id",
            Descriptor::Privilege.joins(action: :system_controller).where("descriptor_privileges.descriptors_id = descriptors.id and system_controller_actions.name = 'index'").arel.exists.as("has_index"),
            Descriptor::Privilege.joins(action: :system_controller).where("descriptor_privileges.descriptors_id = descriptors.id and system_controller_actions.name = 'show'").arel.exists.as("has_show"),
            Descriptor::Privilege.joins(action: :system_controller).where("descriptor_privileges.descriptors_id = descriptors.id and system_controller_actions.name = 'create'").arel.exists.as("has_create"),
            Descriptor::Privilege.joins(action: :system_controller).where("descriptor_privileges.descriptors_id = descriptors.id and system_controller_actions.name = 'update'").arel.exists.as("has_update"),
            Descriptor::Privilege.joins(action: :system_controller).where("descriptor_privileges.descriptors_id = descriptors.id and system_controller_actions.name = 'destroy'").arel.exists.as("has_destroy")
        )
    end

end
