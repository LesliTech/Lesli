class CreateRoleDescriptorAssignments < ActiveRecord::Migration[6.1]
    def change
        create_table :role_descriptor_assignments do |t|

            t.string   :category
            
            t.datetime :deleted_at, index: true
            t.timestamps
        end
        
        add_reference   :role_descriptor_assignments, :role_descriptors, foreign_key: true, index: { name: "role_descriptors_roles" }
        add_reference   :role_descriptor_assignments, :roles, foreign_key: true, index: { name: "role_descriptor_assignments_roles" }
    end
end
