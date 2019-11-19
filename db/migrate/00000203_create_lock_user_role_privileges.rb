class CreateLockUserRolePrivileges < ActiveRecord::Migration[6.0]
    def change
        create_table :lock_user_role_privileges do |t|
            t.timestamps
        end
        add_reference :lock_user_role_privileges, :lock_user_roles, foreign_key: true
    end
end
