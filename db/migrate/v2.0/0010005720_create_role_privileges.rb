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

        # Production instances have previous implementation of role_privileges and is needed to drop it
        if ActiveRecord::Base.connection.table_exists? 'role_privileges'
            drop_table :role_privileges
        end

        create_table :role_privileges do |t|
            t.string   :controller
            t.string   :action
            t.string   :form
            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :role_privileges, :roles, foreign_key: true
        add_index(:role_privileges, [:controller, :action, :form, :roles_id], unique: true, name: 'role_privilege_controller_action')
    end
end
