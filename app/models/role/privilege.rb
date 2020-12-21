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

class Role::Privilege < ApplicationRecord
    belongs_to :role, foreign_key: "roles_id"


    def self.index(role)
        role.privileges.select(
            :id,
            :grant_object,
            :grant_index,
            :grant_list,
            :grant_create,
            :grant_new,
            :grant_edit,
            :grant_show,
            :grant_update,
            :grant_destroy,
            :grant_options,
            :grant_resources,
            :grant_search,
            :created_at,
            :updated_at
        )
        .order(:grant_object, :id)
    end
end
