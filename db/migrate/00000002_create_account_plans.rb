class CreateAccountPlans < ActiveRecord::Migration[5.2]
    def change
        create_table :account_plans do |t|

            t.timestamps
        end
    end
end
