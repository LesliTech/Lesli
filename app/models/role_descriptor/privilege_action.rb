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
class RoleDescriptor::PrivilegeAction < ApplicationLesliRecord
    belongs_to :role_descriptor,    foreign_key: "role_descriptors_id",             class_name: "RoleDescriptor"  
    belongs_to :system_action,      foreign_key: "system_controller_actions_id",    class_name: "SystemController::Action"
    
    enum category: {
        index:   'index',
        create:  'create',
        update:  'update',
        show:    'show',
        destroy: 'destroy',
        search:  'search'
    }, _suffix: true
    
    def self.index(current_user, role_descriptor, query)        
        actions = role_descriptor.privilege_actions.select(
            "role_descriptor_privilege_actions.id",
            :status,
            :category,
            "system_controllers.name as controller",
            "system_controllers.id as controller_id",
            "system_controller_actions.name as action",
            "system_controller_actions.id as action_id"
        )
        .joins(system_action: [:system_controller] )
        
        actions
    end
    
    def show(current_user, query)
        self
    end
    
    def self.options(current_user)        
        options = { 
            system_controllers: SystemController.joins(:actions).select(
                "system_controllers.name as controller",
                "system_controllers.id as controller_id",
                "system_controller_actions.name as action",
                "system_controller_actions.id as action_id",
                "case system_controller_actions.name -- USED TO ORDER THE ACTIONS
                    when 'index'   then 1
                    when 'show'    then 2
                    when 'new'     then 3
                    when 'edit'    then 4
                    when 'create'  then 5
                    when 'update'  then 6
                    when 'destroy' then 7
                    when 'options' then 8
                    else 9
                end as importance
                "
            )
            .order("system_controllers.name, importance, system_controller_actions.name"),
            categories: self.categories.map {|k, _| {value: k, text: k}},
        }
        
        return options
    end
end
