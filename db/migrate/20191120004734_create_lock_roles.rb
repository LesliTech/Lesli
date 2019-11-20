class CreateLockRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :lock_roles do |t|

      t.timestamps
    end
  end
end
