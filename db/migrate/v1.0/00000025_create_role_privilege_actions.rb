class CreateRolePrivilegeActions < ActiveRecord::Migration[6.1]
    def change
        create_table :role_privilege_actions do |t|
            t.string :name
            t.boolean :status

            t.datetime :deleted_at, index: true

            t.timestamps
        end

        add_reference   :role_privilege_actions, :roles, foreign_key: true, index: { name: "role_privilege_actions_roles" }
        # Reference added on system controllers migration
    end
end
