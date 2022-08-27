class CreateRolePrivileges < ActiveRecord::Migration[7.0]
    def change
        create_table :role_privileges do |t|
            t.boolean  :active
            t.string   :controller
            t.string   :action
            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :role_privileges, :roles, foreign_key: true
        add_index(
            :role_privileges, [:controller, :action, :roles_id], unique: true,
            name: 'role_privilege_controller_action'
        )
    end
end
