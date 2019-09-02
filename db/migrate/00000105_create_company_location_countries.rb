class CreateCompanyLocationCountries < ActiveRecord::Migration[6.0]
    def change
        create_table :company_location_countries do |t|

            t.timestamps
        end
        add_reference :company_location_countries, :company_location_continents, foreign_key: true, index: {name: 'company_location_countries_continents'}
    end
end
