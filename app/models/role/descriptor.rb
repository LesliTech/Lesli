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

    def synchronize_privileges
        # Syncronize the descriptor privileges with the role privilege cache table 
        Role::PrivilegeService.new.synchronize_privileges(self.roles_id)
    end 

    def self.index current_user, query, role

        # get the active descriptors assigned to the role
        fromrole = role.descriptors
        .joins(system_descriptor: :system_controller)
        .select(
            "system_descriptors_id as id", 
            "system_descriptors.name as name", 
            "system_controllers.reference as reference", 
            "system_controllers.route as controller", 
            "system_descriptors.category as action",
            "system_controllers.engine as engine", 
            "true as active"
        )

        #return fromrole
        # get all the available descriptors in the platform
        available = ::SystemDescriptor.joins(:system_controller)
        .select(
            "system_descriptors.id as id", 
            "system_descriptors.name as name", 
            "system_controllers.reference as reference", 
            "system_controllers.route as controller", 
            "system_descriptors.category as action",
            "system_controllers.engine as engine", 
            "false as active"
        )


        #unless query[:search].blank?
            #search_string = LC::Sql.sanitize_for_like(query[:search])
            #sql = "lower(name) like :s or lower(engine) like :s or lower(controller) like :s or lower(action) like :s"
            #fromrole = fromrole.where(sql, :s => search_string)
            #available = available.where(sql, :s => search_string)
        #end

        # join descriptors (active & available) so we return a list of descriptor including info
        # about which descriptor is enabled
        return (fromrole + available).uniq{ |p| p[:id] }

    end
end
