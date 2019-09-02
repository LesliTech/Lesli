class CreateCompanyCurrencies < ActiveRecord::Migration[6.0]
    def change
        create_table :company_currencies do |t|

            t.timestamps
        end
        add_reference :company_currencies, :accounts, foreign_key: true
    end
end
