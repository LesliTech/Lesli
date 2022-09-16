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
class Role::Describer < ApplicationLesliRecord
    belongs_to :role,       foreign_key: "roles_id"
    belongs_to :descriptor, foreign_key: "descriptors_id"

    after_commit :synchronize_privileges, on: [:create, :update, :destroy]

    def self.index current_user, query, role

        # get the active descriptors assigned to the role
        fromrole = role.describers.joins(:descriptor).select("descriptors_id as id", :name, :reference, :controller, :action, :engine, "true as active")

        # get all the available descriptors in the platform
        available = current_user.account.descriptors.select(:id, :name, :reference, :controller, :action, :engine, "false as active")

        unless query[:search].blank?
            search_string = LC::Sql.sanitize_for_like(query[:search])

            sql = "lower(name) like :s or lower(engine) like :s or lower(controller) like :s or lower(action) like :s"

            fromrole = fromrole.where(sql, :s => search_string)
            available = available.where(sql, :s => search_string)
        end

        # join descriptors (active & available) so we return a list of descriptor including info
        # about which descriptor is enabled
        (fromrole + available).uniq{ |p| p[:id] }

    end 

    private

    def synchronize_privileges
        # Syncronize the descriptor privileges with the role privilege cache table 
        RolePrivilegesService.new.synchronize_privileges
    end 

end
