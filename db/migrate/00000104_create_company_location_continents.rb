class CreateCompanyLocationContinents < ActiveRecord::Migration[6.0]
    def change
        create_table :company_location_continents do |t|

        t.timestamps
        end
        add_reference :company_location_continents, :accounts, foreign_key: true
    end
end
