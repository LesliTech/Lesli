class CreateCoreAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :core_accounts do |t|

      t.timestamps
    end
    add_reference :core_accounts, :core_account_plans, foreign_key: true
    add_reference :core_accounts, :core_account_details, foreign_key: true
  end
end
