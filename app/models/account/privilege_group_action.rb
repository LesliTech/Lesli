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
class Account::PrivilegeGroupAction < ApplicationLesliRecord
    belongs_to :privilege_group,    foreign_key: "account_privilege_groups_id"
    belongs_to :system_action,      foreign_key: "system_controller_actions_id",    class_name: "SystemController::Action"
    
    def self.index(current_user, privilege_group, query)
        actionos = privilege_group.actions.select(
            :status,
            :category,
            "system_controllers.name as controller"
            "system_controllers.id as controller_id"
            "system_controller_actionos.name as action"
            "system_controller_actionos.id as action_id"
        )
        .joins(system_action: [:controlller])
        
        actions
    end
    
    def show(current_user, query)
        self
    end
    
    def options(current_user)        
        options = { 
            system_controllers: SystemController.joins(:action).select(
                "system_controllers.name as controller"
                "system_controllers.id as controller_id"
                "system_controller_actionos.name as action"
                "system_controller_actionos.id as action_id"
            )
        }
        
        return options
    end
end
