class CreateRoleDescriptorPrivilegeActions < ActiveRecord::Migration[6.1]
    def change
        create_table :role_descriptor_privilege_actions do |t|
            t.string :category
            t.boolean :status

            t.datetime :deleted_at, index: true

            t.timestamps
        end
        add_reference   :role_descriptor_privilege_actions, :role_descriptors, foreign_key: true, index: { name: "role_descriptor_privilege_actions_role_descriptors" }
        add_reference   :role_descriptor_privilege_actions, :system_controller_actions, foreign_key: true, index: { name: "role_descriptor_privilege_actions_system_controller_actions" }
    end
end
