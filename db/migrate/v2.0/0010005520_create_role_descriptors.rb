class CreateRoleDescriptors < ActiveRecord::Migration[7.0]
    def change
        create_table :role_descriptors do |t|
            t.string :category
            
            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :role_descriptors, :roles, foreign_key: true
        add_reference :role_descriptors, :descriptors, foreign_key: true
        add_reference :role_descriptors, :user, foreign_key: true
    end
end
