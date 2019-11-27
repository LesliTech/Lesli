class CreateUserRoleOverrides < ActiveRecord::Migration[6.0]
  def change
    create_table :user_role_overrides, :id => false do |t|
        t.timestamps
    end
    add_reference :user_role_overrides, :users, foreign_key: true
    add_reference :user_role_overrides, :lock_role_overrides, foreign_key: true
  end
end
