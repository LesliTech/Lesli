class CreateLockUserPrivileges < ActiveRecord::Migration[6.0]
    def change
        create_table :lock_user_privileges do |t|
            t.timestamps
        end
        add_reference :lock_user_privileges, :users, foreign_key: true
    end
end
