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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

class CreateLesliRoleDescriptors < ActiveRecord::Migration[7.0]
    def change
        create_table :lesli_role_descriptors do |t|
            t.boolean :plist    # enables all the index privileges in the descriptor
            t.boolean :pindex   # enables all the index privileges in the descriptor
            t.boolean :pshow    # enables all the show privileges in the descriptor
            t.boolean :pcreate  # enables all the create privileges in the descriptor
            t.boolean :pupdate  # enables all the update privileges in the descriptor
            t.boolean :pdestroy # enables all the destroy privileges in the descriptor

            t.datetime :deleted_at, index: true
            t.timestamps
        end

        add_reference(:lesli_role_descriptors, :user, foreign_key: { to_table: :lesli_users })
        add_reference(:lesli_role_descriptors, :role, foreign_key: { to_table: :lesli_roles })
        add_reference(:lesli_role_descriptors, :descriptor, foreign_key: { to_table: :lesli_descriptors })
    end
end
