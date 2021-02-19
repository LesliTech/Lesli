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
class User::Activity < ApplicationRecord
    belongs_to :user,   foreign_key: "users_id",    class_name: "::User"
    belongs_to :owner,  foreign_key: "owner_id",    class_name: "::User" 
    

    enum category: {
        action_create:                          "action_create",
        action_show:                            "action_show",
        action_update:                          "action_update",
        action_destroy:                         "action_destroy",
        action_create_user_role:                "action_create_user_role",
        action_destroy_user_role:               "action_destroy_user_role",
        action_become:                          "action_become"
    }
end
