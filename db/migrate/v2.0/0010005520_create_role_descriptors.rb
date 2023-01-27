class CreateRoleDescriptors < ActiveRecord::Migration[7.0]
    def change
        create_table :role_descriptors do |t|
            t.boolean :privilege_index
            t.boolean :privilege_show
            t.boolean :privilege_create
            t.boolean :privilege_update
            t.boolean :privilege_destroy
            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :role_descriptors, :roles, foreign_key: true
        add_reference :role_descriptors, :descriptors, foreign_key: true
        add_reference :role_descriptors, :user, foreign_key: true
    end
end
