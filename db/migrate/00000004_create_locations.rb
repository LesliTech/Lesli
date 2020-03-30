class CreateLocations < ActiveRecord::Migration[6.0]
    def change
        create_table :locations do |t|
            t.string        :name
            t.string        :level      # For example, country, state, city, municipio, etc.
            t.string        :parent_id

            t.timestamps
        end

        add_reference :locations, :locations, foreign_key: true
        add_reference :locations, :accounts, foreign_key: true
    end
end
