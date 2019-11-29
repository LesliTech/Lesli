class CreateUserDetails < ActiveRecord::Migration[6.0]
    def change
        create_table :user_details do |t|
            t.string :name
            t.string :first_name
            t.string :last_name
            t.string :telephone
            t.string :address
            t.timestamps
        end
        add_reference :user_details, :users, foreign_key: true
    end
end
