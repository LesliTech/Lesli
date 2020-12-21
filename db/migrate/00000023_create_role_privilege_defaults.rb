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

class CreateRolePrivilegeDefaults < ActiveRecord::Migration[6.0]
    def change
        create_table :role_privilege_defaults do |t|
            t.string  :grant_object

            t.boolean :grant_list,      default: false
            t.boolean :grant_index,     default: false

            t.boolean :grant_edit,      default: false
            t.boolean :grant_show,      default: false
            t.boolean :grant_new,       default: false

            t.boolean :grant_create,    default: false
            t.boolean :grant_update,    default: false
            t.boolean :grant_destroy,   default: false

            t.boolean :grant_search,    default: false

            t.boolean :grant_resources, default: false
            t.boolean :grant_options,   default: false

            t.datetime :deleted_at, index: true

            t.timestamps
        end
        add_reference :role_privilege_defaults, :roles, foreign_key: true
    end
end
