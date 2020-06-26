class CreateRolePrivilegeDefaults < ActiveRecord::Migration[6.0]
  def change
    create_table :role_privilege_defaults do |t|

      t.timestamps
    end
  end
end
