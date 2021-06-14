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
    end
end