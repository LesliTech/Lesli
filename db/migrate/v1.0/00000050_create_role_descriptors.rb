class CreateRoleDescriptors < ActiveRecord::Migration[6.1]
    def change
        create_table :role_descriptors do |t|

            t.string  :name
            t.boolean :status
            t.text    :description
            
            t.datetime :deleted_at, index: true

            t.timestamps
        end

        add_reference :role_descriptors, :users, foreign_key:true
        add_reference :role_descriptors, :accounts, foreign_key:true
        add_reference :role_descriptors, :role_descriptors, foreign_key:true
    end
end
