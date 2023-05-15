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
    belongs_to :role, foreign_key: "roles_id"
    belongs_to :system_descriptor, foreign_key: "system_descriptors_id"

    after_save :synchronize_privileges
    after_destroy :synchronize_privileges

    def self.index current_user, query, role

        # get the active descriptors assigned to the role
        SystemDescriptor
        .joins(:system_controller)
        .joins(%(
            LEFT OUTER JOIN "role_descriptors" 
            ON "role_descriptors"."deleted_at" IS NULL 
            AND "role_descriptors"."system_descriptors_id" = "system_descriptors"."id"
            AND "role_descriptors"."roles_id" = #{role.id}
        ))
        .select(
            "coalesce(role_descriptors.system_descriptors_id, system_descriptors.id) as id", 
            "system_descriptors.name as name", 
            "system_controllers.reference as reference", 
            "system_controllers.route as controller", 
            "system_descriptors.category as action", 
            "system_controllers.engine as engine", 
            "case when role_descriptors.system_descriptors_id is null then false else true end as active"
        )
    end

    def synchronize_privileges
        PrivilegeServices.new(self.role.id).synchronize
    end
end
