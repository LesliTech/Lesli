class CreateCoreUserDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :core_user_details do |t|

      t.timestamps
    end
    add_reference :core_user_details, :users, foreign_key: true
    add_reference :core_user_details, :core_user_roles, foreign_key: true
    add_reference :core_user_details, :core_accounts, foreign_key: true
  end
end
