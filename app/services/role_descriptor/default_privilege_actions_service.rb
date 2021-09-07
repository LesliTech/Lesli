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

class RoleDescriptor::DefaultPrivilegeActionsService
    
    def initialize
    end
      
    # @return [Array] of SystemController::Action
    # @description Return the list of privilege actions defined for 
    # profile descriptor 
    # Example
    # actions = RoleDescriptor::DefaultPrivilegeActionsService.profile_actions
    def profile_actions 
        actions = []
        
        [   
            {controller: "profiles", actions: ["show"] },
            {controller: "users",    actions: ["options", "update"] },
            {controller: "user/sessions", actions: ["index"] }
        ].each do |privilege|
            privilege[:actions].each do |action|
            
                system_action = SystemController::Action.joins(:system_controller)
                .where("system_controllers.name = ?", privilege[:controller])
                .where("system_controller_actions.name = ?", action)
                .first
                
                actions.push(system_action) if system_action
            end
        end 
        
        return actions
    end
end