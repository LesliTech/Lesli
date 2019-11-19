class CreateLockUserDetails < ActiveRecord::Migration[6.0]
    def change
        create_table :lock_user_details do |t|
            t.timestamps
        end
        add_reference :lock_user_details, :users, foreign_key: true
    end
end
