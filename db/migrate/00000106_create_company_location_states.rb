class CreateCompanyLocationStates < ActiveRecord::Migration[6.0]
    def change
        create_table :company_location_states do |t|

            t.timestamps
        end
        add_reference :company_location_states, :company_location_countries, foreign_key: true
    end
end
