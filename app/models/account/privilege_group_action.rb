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
    
    enum category: {
        index:   'index',
        create:  'create',
        update:  'update',
        show:    'show',
        destroy: 'destroy',
        search:  'search'
    }, _suffix: true
    
    def show(current_user, query)
        self
    end
    
    def self.options(current_user)        
        options = { 
            system_controllers: SystemController.joins(:actions).select(
                "system_controllers.name as controller",
                "system_controllers.id as controller_id",
                "system_controller_actions.name as action",
                "system_controller_actions.id as action_id"
            ),
            categories: self.categories.map {|k, _| {value: k, text: k}},
        }
        
        return options
    end
end
