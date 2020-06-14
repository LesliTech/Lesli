=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class CreateAccountLocations < ActiveRecord::Migration[6.0]
    def change
        create_table :account_locations do |t|

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
