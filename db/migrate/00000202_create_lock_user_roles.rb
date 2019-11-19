class CreateLockUserRoles < ActiveRecord::Migration[6.0]
    def change
        create_table :lock_user_roles do |t|
            t.timestamps
        end
        add_reference :lock_user_roles, :locks, foreign_key: true
    end
end
