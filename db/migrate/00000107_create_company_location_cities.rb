class CreateCompanyLocationCities < ActiveRecord::Migration[6.0]
    def change
        create_table :company_location_cities do |t|

            t.timestamps
        end
        add_reference :company_location_cities, :company_location_states, foreign_key: true
    end
end
