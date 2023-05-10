class CreateSystemDescriptorPrivileges < ActiveRecord::Migration[7.0]
    def change
        create_table :system_descriptor_privileges do |t|
            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :system_descriptor_privileges, :system_controller_actions, foreign_key: true, index: { name: "system_descriptor_privileges_controller_actions" }
        add_reference :system_descriptor_privileges, :system_descriptors, foreign_key:true
    end
end
