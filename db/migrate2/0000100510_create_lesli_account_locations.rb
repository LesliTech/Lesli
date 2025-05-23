=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·
=end

class CreateLesliAccountLocations < ActiveRecord::Migration[6.0]
    def change
        create_table :lesli_account_locations do |t|

            # General information about the location
            t.string :name
            t.string :short_name
            t.string :postal_code
            t.string :latitude
            t.string :longitude
            t.string :code
            t.string :calling_code

            # Imagine USA, we have country > state > city. In guatemala, we have country > departamento > municipio
            # levels for Guatemala, Alta Verapaz, Cobán will be country, state, city
            # native_levels for Guatemala, Alta Verapaz, Cobán will be country, departamento, municipio
            # native_levels are only reference, for relating entries we will use the 'level' field
            t.string :level          # For example, country, state, city, etc.
            t.string :native_level   # The original name of the level, based on language and location

            # acts_as_paranoid
            t.datetime :deleted_at, index: true

            t.timestamps
        end

        add_reference(:lesli_account_locations, :parent, foreign_key: { to_table: :lesli_account_locations })
        add_reference(:lesli_account_locations, :account, foreign_key: { to_table: :lesli_accounts })
        add_index(:lesli_account_locations, %i[account_id name level parent_id], unique: true,
                                                                           name: "location_uniqueness_index")
    end
end
