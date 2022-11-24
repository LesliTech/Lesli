class AlterAccounts < ActiveRecord::Migration[7.0]
    def change
        add_column :accounts, :city,    :string
        add_column :accounts, :postal_code,    :string
    end
end
