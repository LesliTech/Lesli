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

    # Syncronize the descriptor privileges with the role privilege cache table 
    def synchronize_privileges
    
        # bulk all the descriptor privileges
        # this script was built manually for performance, maintenance
        # and to make it easy to read for future changes, basically what it does 
        # is get the controllers and actions assigned to a descriptor through the 
        # system_descriptor_privileges table and save a cache into role_privileges
        records = SystemDescriptor.joins(%(
            INNER JOIN system_descriptor_privileges
            ON system_descriptor_privileges.system_descriptors_id = system_descriptors.id
        )).joins(%(
            INNER JOIN system_controller_actions 
            ON system_controller_actions .id = system_descriptor_privileges.system_controller_actions_id
        )).joins(%(
            INNER JOIN system_controllers 
            ON system_controllers.id = system_controller_actions.system_controllers_id
        )).joins(%(
            INNER JOIN role_descriptors 
            ON role_descriptors.system_descriptors_id = system_descriptors.id
        )).select(
            "system_controllers.route as controller", 
	        "system_controller_actions.name as action",
            "case when role_descriptors.deleted_at is null then true else false end as active",
            "role_descriptors.roles_id as roles_id"
        ).with_deleted

        # synchronize only for the given role, this is needed to sync only modified roles
        records = records.where("role_descriptors.roles_id" => self.role.id)
        
        # convert the results to json so it is easy to insert/update
        records = records.as_json(only: [:controller, :action, :roles_id, :active])

        # small check to ensure I have records to update/insert
        return if records.blank?

        # bulk update/insert into role privilege cache table
        # IMPORTANT: Due to the importance and how delicate this process is, it is better
        #            to copy the controller name and actions from the system, instead of 
        #            just have a reference to the system_controller_actions table
        Role::Privilege.with_deleted.upsert_all(records, unique_by: [:controller, :action, :roles_id])
    end 
end
