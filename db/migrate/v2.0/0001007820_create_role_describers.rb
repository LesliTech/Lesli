class CreateRoleDescribers < ActiveRecord::Migration[7.0]
    def change
        create_table :role_describers do |t|
            t.timestamps
            t.datetime :deleted_at, index: true
        end
        add_reference :role_describers, :roles, foreign_key: true
        add_reference :role_describers, :descriptors, foreign_key: true
    end
end
