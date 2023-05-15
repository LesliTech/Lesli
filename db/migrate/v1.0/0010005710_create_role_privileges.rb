=begin

Copyright (c) 2022, all rights reserved.

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

class CreateRolePrivileges < ActiveRecord::Migration[7.0]
    def change
        create_table :role_privileges do |t|
            t.string   :controller
            t.string   :action
            t.boolean  :active
            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference(:role_privileges, :roles, foreign_key: true)
        add_index(:role_privileges, [:controller, :action, :roles_id], unique: true, name: 'role_privileges_index')
        #add_index(:role_privileges, [:controller, :action, :active, :roles_id], unique: true, name: 'role_privileges_full_index')
    end
end
