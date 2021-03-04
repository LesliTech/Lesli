class CreateUserAccessCodes < ActiveRecord::Migration[6.1]
    def change
        create_table :user_access_codes do |t|
            t.string :otp_secret
            t.integer :last_otp_at

            t.datetime :deleted_at, index: true

            t.timestamps
        end
        add_reference :user_access_codes, :users, foreign_key: true
    end
end
