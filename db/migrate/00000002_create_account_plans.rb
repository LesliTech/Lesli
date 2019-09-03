class CreateAccountPlans < ActiveRecord::Migration[5.2]
    def change
        create_table :account_plans do |t|
            t.string :name
        end
        execute "insert into account_plans (id, name) values (0, 'demo')"
    end
end
