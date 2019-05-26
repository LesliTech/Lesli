class CreateCoreAccountPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :core_account_plans do |t|

      t.timestamps
    end
  end
end
