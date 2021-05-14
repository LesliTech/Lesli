class AddAccountCreator < ActiveRecord::Migration[6.1]
    def change
        add_reference :account_files, :users, foreign_key: true
    end
end
