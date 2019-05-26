class CreateCoreUserRolePrivileges < ActiveRecord::Migration[5.2]
  def change
    create_table :core_user_role_privileges do |t|

      t.timestamps
    end
  end
end
