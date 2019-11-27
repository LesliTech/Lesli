class CreateLockRoleOverrides < ActiveRecord::Migration[6.0]
    def change
=begin 
        create_table :lock_role_overrides do |t|
            t.boolean :get, default: false
            t.boolean :post, default: false
            t.boolean :put, default: false
            t.boolean :delete, default: false
            t.timestamps
        end
        add_reference :lock_role_overrides, :locks, foreign_key: true
=end
    end
end
