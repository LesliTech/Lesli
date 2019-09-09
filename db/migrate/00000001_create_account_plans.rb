class CreateAccountPlans < ActiveRecord::Migration[5.2]
    def change
        create_table :account_plans do |t|
            t.string    :name
            t.decimal   :price, precision: 12, scale: 6
        end
    end
end
