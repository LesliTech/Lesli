class CreateAccountPrivilegeGroups < ActiveRecord::Migration[6.1]
    def change
        create_table :account_privilege_groups do |t|
            t.string  :name
            t.boolean :status
            t.text    :description
            
            t.datetime :deleted_at, index: true

            t.timestamps
        end

        add_reference :account_privilege_groups, :accounts, foreign_key:true
        add_reference :account_privilege_groups, :account_privilege_groups, foreign_key:true
    end
end