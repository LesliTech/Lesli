class CreateCoreUserRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :core_user_roles do |t|

      t.timestamps
    end
    add_reference :core_user_roles, :core_user_role_privileges, foreign_key: true
  end
end
