class CreateAccounts < ActiveRecord::Migration[5.2]
    def change
        create_table :accounts do |t|

            t.timestamps
        end
        add_reference :accounts, :users, foreign_key: true
        add_reference :accounts, :account_plans, foreign_key: true
    end
end
