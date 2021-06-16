class CreateRolePrivilegeGroups < ActiveRecord::Migration[6.1]
    def change
        create_table :role_privilege_groups do |t|
            t.string   :category
            
            t.datetime :deleted_at, index: true
            t.timestamps
        end
        
        add_reference   :role_privilege_groups, :account_privilege_groups, foreign_key: true, index: { name: "account_privilege_groups_roles" }
        add_reference   :role_privilege_groups, :roles, foreign_key: true, index: { name: "role_privilege_groups_roles" }
    end
end
