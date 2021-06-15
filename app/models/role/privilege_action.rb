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
class Role::PrivilegeAction < ApplicationLesliRecord
    belongs_to :role, foreign_key: "roles_id"
    belongs_to :action, foreign_key: "system_controller_actions_id",    class_name: "SystemController::Action"
    
    def self.options(current_user, query)
        groups = []
        categories_name = Account::PrivilegeGroupAction.categories.map{|k, _| k}

        
        current_user.account.privilege_groups.order(created_at: :asc).each do |privilege_group|
            actions = {}            
            privilege_group_actions = privilege_group.actions
            
            categories_name.each do |category|
                actions[category] =  { 
                    actions: privilege_group_actions.find_all {|e| e["category"] == category },
                    status: false
                }
            end
            
            groups.push({
                actions: actions,
                id: privilege_group.id,
                name: privilege_group.name,
                description: privilege_group.description,
                account_privilege_groups_id: privilege_group.account_privilege_groups_id
            }) 
        end
        
        return {
            groups: groups,
            categories: categories_name
        }
    end
end
