class CreateLockRoleOverrides < ActiveRecord::Migration[6.0]
    def change
        create_table :lock_role_overrides do |t|
            t.timestamps
        end
        add_reference :lock_role_overrides, :locks, foreign_key: true
    end
end
