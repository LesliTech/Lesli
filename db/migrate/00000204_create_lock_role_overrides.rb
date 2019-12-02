class CreateLockRoleOverrides < ActiveRecord::Migration[6.0]
    def change
=begin 
        create_table :lock_role_overrides do |t|
            t.boolean :privilege_get, default: false
            t.boolean :privilege_post, default: false
            t.boolean :privilege_put, default: false
            t.boolean :privilege_delete, default: false
            t.timestamps
        end
        add_reference :lock_role_overrides, :locks, foreign_key: true
=end
    end
end
