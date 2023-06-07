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

class PrivilegeServices < ApplicationLesliServices

    @roles;

    def initialize *roles
        @roles = roles
    end

    # Syncronize the descriptor privileges with the role privilege cache table 
    def synchronize 

        # bulk all the descriptor privileges
        # this script was built manually for performance, maintenance
        # and to make it easy to read for future changes, basically what it does 
        # is get the controllers and actions assigned to a descriptor through the 
        # system_descriptor_privileges table and create an array of hashes with
        # all the raw privileges (this includes duplicated privileges)
        records = SystemDescriptor.joins(%(
            INNER JOIN system_descriptor_privileges
            ON system_descriptor_privileges.system_descriptor_id = system_descriptors.id
        )).joins(%(
            INNER JOIN system_controller_actions 
            ON system_controller_actions.id = system_descriptor_privileges.system_controller_action_id
        )).joins(%(
            INNER JOIN system_controllers 
            ON system_controllers.id = system_controller_actions.system_controller_id
        )).joins(%(
            INNER JOIN role_descriptors 
            ON role_descriptors.system_descriptor_id = system_descriptors.id
        )).select(
            "system_controllers.route as controller", 
            "system_controller_actions.name as action",
            "case when role_descriptors.deleted_at is null then true else false end as active",
            "role_descriptors.role_id as role_id"
        ).with_deleted

        # get privileges only for the given role, this is needed to sync only modified roles
        records = records.where("role_descriptors.role_id" => roles)

        # we use the deleted_at column to know if a privilege is enable or disable, NULL values
        # at the deleted_at column means privilege is active, so if we sort by deleted_at column
        # all the active privileges will be at the top, then the uniq method is going to take
        # always the active values, to completely disable a privilege for a specific controller/action
        # we have to disable in all the descriptors
        records = records.order("role_descriptors.deleted_at DESC")
        
        # convert the results to json so it is easy to insert/update
        records = records.as_json(only: [:controller, :action, :role_id, :active])

        # IMPORTANT: We must save only uniq privileges in the role_privilege table
        # this means that it does not matters how many times we defined a privilege dependency
        # we insert the privilege only once.
        # Example: If we defined that we need access to UsersController#index in 20 descriptors,
        # in the role_privileges will be only one record for that specific controller and action
        records = records.uniq do |privilege|

            # NOTE: If can disable a privilege that belongs to a descriptor, 
            # however, if the same privilege is define in another active descriptor, 
            # the role that has both descriptor will be able to access the resources 
            # of that privilege, that is a normal and desire behavior.
            [privilege["controller"], privilege["action"], privilege["role_id"]]
        end

        # small check to ensure I have records to update/insert
        return if records.blank?

        # bulk update/insert into role privilege cache table
        # IMPORTANT: Due to the importance and how delicate this process is, it is better
        #            to copy the controller name and actions from the system, instead of 
        #            just have a reference to the system_controller_actions table
        Role::Privilege.with_deleted.upsert_all(records, unique_by: [:controller, :action, :role_id])
    end 

    private 

    attr_reader :roles
end
