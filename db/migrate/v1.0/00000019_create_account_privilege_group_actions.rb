class CreateAccountPrivilegeGroupActions < ActiveRecord::Migration[6.1]
    def change
        create_table :account_privilege_group_actions do |t|
            t.string :category
            t.boolean :status 
               
            t.datetime :deleted_at, index: true
            
            t.timestamps
        end
        
        add_reference   :account_privilege_group_actions, :account_privilege_groups, foreign_key:true, index: { name: "account_privilege_group_actions_account_privilege_groups" }
        add_reference   :account_privilege_group_actions, :system_controller_actions, foreign_key: true, index: { name: "account_privilege_group_actions_roles_system_controller_actions" }
    end
end
