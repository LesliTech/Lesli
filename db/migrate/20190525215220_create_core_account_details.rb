class CreateCoreAccountDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :core_account_details do |t|

      t.timestamps
    end
  end
end
