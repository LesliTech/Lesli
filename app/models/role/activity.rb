=begin
    
Copyright (c) 2020, all rights reserved.

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
class Role::Activity < ApplicationLesliRecord
    belongs_to :role,           foreign_key: "roles_id"
    belongs_to :user_creator,   foreign_key: "users_id", class_name: "::User", optional: true

    enum category: {
        action_create:                          "action_create",
        action_show:                            "action_show",
        action_update:                          "action_update",
        action_destroy:                         "action_destroy",
        action_update_role_privilege:           "action_update_role_privilege",
        action_create_role_privilege:           "action_create_role_privilege"
    }
end
