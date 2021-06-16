=begin
Copyright (c) 2021, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permssion of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
class Role::PrivilegeGroup < ApplicationRecord
    belongs_to :role,               foreign_key: "roles_id",    class_name: "::Role"
    belongs_to :group,              foreign_key: "account_privilege_groups_id",  class_name: "::Account::PrivilegeGroup"
    
    # after_create  :add_privilege_actions
    # after_destroy :remove_privilege_actions
    
    # def add_privilege_actions
    #     actions_id = Account::PrivilegeGroup.where(id: self.group.id)
    #     .select("account_privilege_group_actions.system_controller_actions_id as action_id")
    #     .joins(:actions)
    #     .where("account_privilege_group_actions.category = ?", self.category)
    #     .where("account_privilege_group_actions.status = ?", FALSE)
    #     .map(&:action_id)
        
    #     self.role.privilege_actions.where(system_controller_actions_id: actions_id).update_all(status: true)
    # end
    
    # def remove_privilege_actions
    #     actions_id = self.available_actions
               
    #     unless actions_id.blank?
    #         self.role.privilege_actions.where(system_controller_actions_id: actions_id).update_all(status: false)
    #     end
    # end
    
    # private
    
    # def available_actions  
    #     Account::PrivilegeGroup.where(id: self.group.id)
    #     .select("
    #         account_privilege_group_actions.system_controller_actions_id as action_id
    #     ")
    #     .joins(:actions)
    #     .joins("
    #         left join (
    #             select
    #                 apga.system_controller_actions_id as id
    #             from
    #                 role_privilege_groups rpg 
    #             inner join account_privilege_groups apg 
    #                 on  apg.id = rpg.account_privilege_groups_id
    #                 and apg.deleted_at is null
    #             inner join account_privilege_group_actions apga 
    #                 on  apga.account_privilege_groups_id = apg.id 
    #                 and apga.status = 'TRUE'
    #             where rpg.roles_id =  #{self.role.id}
    #             and rpg.id != #{self.id}
    #         ) as actions
    #         on actions.id = account_privilege_group_actions.system_controller_actions_id
    #     ")
    #     .where("account_privilege_group_actions.category = ?", self.category)
    #     .where("account_privilege_group_actions.status = ?", TRUE)
    #     .where("actions.id is null")
    #     .map(&:action_id)
    # end
    
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
