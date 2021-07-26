=begin
Copyright (c) 2021, all rights reserved.

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
class Role::DescriptorAssignment < ApplicationLesliRecord
    belongs_to :role,               foreign_key: "roles_id",             class_name: "::Role"
    belongs_to :descriptor,         foreign_key: "role_descriptors_id",  class_name: "::RoleDescriptor"
    
    has_many   :privilege_actions,  through: :descriptor
    
    def self.options(current_user)
        descriptors = []
        categories_name = RoleDescriptor::PrivilegeAction.categories.map{|k, _| k}

        
        current_user.account.role_descriptors.order(created_at: :asc)
        .where.not("role_descriptors.name = ? or role_descriptors.name = ?", "admin", "owner")
        .each do |role_descriptor|
            actions = {}            
            role_descriptor_actions = role_descriptor.privilege_actions
            
            categories_name.each do |category|
                actions[category] =  { 
                    actions: role_descriptor_actions.find_all {|e| e["category"] == category },
                    status: false
                }
            end
            
            descriptors.push({
                actions: actions,
                id: role_descriptor.id,
                name: role_descriptor.name,
                description: role_descriptor.description,
                role_descriptors_id: role_descriptor.role_descriptors_id
            }) 
        end 
        
        return {
            descriptors: descriptors,
            categories: categories_name
        }
    end
end
