class CreateUserDetails < ActiveRecord::Migration[6.0]
    def change
        create_table :user_details do |t|
            t.timestamps
        end
        add_reference :user_details, :users, foreign_key: true
    end
end
