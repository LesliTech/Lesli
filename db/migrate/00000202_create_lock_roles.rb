class CreateLockRoles < ActiveRecord::Migration[6.0]
    def change
        create_table :lock_roles do |t|
            t.string :name
            t.timestamps
        end
        add_reference :lock_roles, :locks, foreign_key: true
    end
end
