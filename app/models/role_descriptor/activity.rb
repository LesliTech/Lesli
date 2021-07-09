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
class RoleDescriptor::Activity < CloudObject::Activity
    belongs_to :role_descriptor,           foreign_key: "role_descriptors_id"
    
    #######################################################################################
    ##############################  Activities Log Methods   ##############################
    #######################################################################################
        
    enum category: {
        action_create:                          "action_create",
        action_show:                            "action_show",
        action_update:                          "action_update",
        action_destroy:                         "action_destroy",
        action_update_role_privilege:           "action_update_role_privilege",
        action_create_role_privilege:           "action_create_role_privilege",
        action_update_privilege_action:         "action_update_privilege_action",
    }
    
    def self.log_create_privilege_action(current_user, role_descriptor, privilege_action)
        self.log_privilege_action(current_user, role_descriptor, privilege_action, false, true)
    end
    
    def self.log_update_privilege_action(current_user, role_descriptor, privilege_action, old_attributes, new_attributes)
        self.log_privilege_action(current_user, role_descriptor, privilege_action, old_attributes[:status], new_attributes[:status])
    end
        
    protected

    def self.log_privilege_action(current_user, role_descriptor, privilege_action, value_from, value_to)
        controller_name = privilege_action.system_action.system_controller.name
        action_nane = privilege_action.system_action.name 
        
        role_descriptor.activities.create(
            user_creator: current_user,
            category: "action_update_privilege_action",
            field_name: action_nane,
            description: controller_name,
            value_from: value_from,
            value_to: value_to
        )
    end
end
