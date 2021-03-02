class CreateAccessCodes < ActiveRecord::Migration[6.1]
    def change
        create_table :access_codes do |t|
            t.string :otp_secret
            t.integer :last_otp_at

            t.datetime :deleted_at, index: true

            t.timestamps
        end
        add_reference :access_codes, :users, foreign_key: true
    end
end
