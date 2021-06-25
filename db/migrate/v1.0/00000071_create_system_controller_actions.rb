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

class CreateSystemControllerActions < ActiveRecord::Migration[6.1]
    def change
        create_table :system_controller_actions do |t|
            t.string :name
            t.datetime :deleted_at, index: true

            t.timestamps
        end

        add_reference :system_controller_actions, :system_controllers, foreign_key: true

        # Add references
        add_reference   :role_privilege_actions, :system_controller_actions, foreign_key: true, index: { name: "system_controller_actions_roles" }
        add_reference   :account_privilege_group_actions, :system_controller_actions, foreign_key: true, index: { name: "account_privilege_group_actions_roles_system_controller_actions" }
        add_reference   :user_privilege_actions, :system_controller_actions, foreign_key: true, index: { name: "system_controller_actions_users" }
    end
end
