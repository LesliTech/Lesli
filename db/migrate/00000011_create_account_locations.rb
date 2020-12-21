=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class CreateAccountLocations < ActiveRecord::Migration[6.0]
    def change
        create_table :account_locations do |t|

            # General information about the location
            t.string        :name
            t.string        :short_name
            t.string        :postal_code
            t.string        :latitude
            t.string        :longitude
            t.string        :code
            t.string        :calling_code

            # Imagine USA, we have country > state > city. In guatemala, we have country > departamento > municipio
            # levels for Guatemala, Alta Verapaz, Cobán will be country, state, city
            # native_levels for Guatemala, Alta Verapaz, Cobán will be country, departamento, municipio
            # native_levels are only reference, for relating entries we will use the 'level' field
            t.string        :level          # For example, country, state, city, etc.
            t.string        :native_level   # The original name of the level, based on language and location
            t.bigint        :parent_id

            # acts_as_paranoid
            t.datetime :deleted_at, index: true

            t.timestamps

        end

        add_foreign_key :account_locations, :account_locations, column: :parent_id
        add_reference :account_locations, :accounts, foreign_key: true
        add_index :account_locations, [:accounts_id, :name, :level, :parent_id], unique: true, name: "location_uniqueness_index"
        add_index :account_locations, :name
        
    end
end
