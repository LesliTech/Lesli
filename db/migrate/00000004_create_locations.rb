class CreateLocations < ActiveRecord::Migration[6.0]
    def change
        create_table :locations do |t|

            # General information acout the location
            t.string        :name
            t.string        :short_name
            t.string        :postal_code
            t.string        :latitude
            t.string        :longitude
            t.string        :code

            # Imagine USA, we have country > state > city. In guatemala, we have country > departamento > municipio
            # levels for Guatemala, Alta Verapaz, Cobán will be country, state, city
            # native_levels for Guatemala, Alta Verapaz, Cobán will be country, departamento, municipio
            # native_levels are only reference, for relating entries we will use the 'level' field
            t.string        :level          # For example, country, state, city, etc.
            t.string        :native_level   # The original name of the level, based on language and location
            t.string        :parent_id

            t.timestamps
        end

        add_reference :locations, :locations, foreign_key: true
        add_reference :locations, :accounts, foreign_key: true
    end
end
