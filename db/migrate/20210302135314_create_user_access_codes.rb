class CreateUserAccessCodes < ActiveRecord::Migration[6.1]
    def change
        create_table :user_access_codes do |t|
            t.string :token
            t.datetime :last_used_at, index: true
            t.datetime :expiration_at

            t.datetime :deleted_at, index: true

            t.timestamps
        end
        add_reference :user_access_codes, :users, foreign_key: true

        add_index :user_access_codes, :token, unique: true
    end
end
