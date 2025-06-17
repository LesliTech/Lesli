=begin

Lesli

Copyright (c) 2025, Lesli Technologies, S. A.

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

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module MigrationHelpers
    module Shared
        module DashboardStructure
            def create_table_lesli_shared_dashboards_10(engine)

                table_name, table_name_account = table_name_for_shared(engine, :dashboards)

                create_table table_name do |t|
                    t.string    :name
                    t.boolean   :default
                    t.json      :components
                    t.datetime  :deleted_at, index: true
                    t.timestamps
                end

                add_reference(table_name, :user, foreign_key: { to_table: :lesli_users }, index: true)
                add_reference(table_name, :role, foreign_key: { to_table: :lesli_roles }, index: true)
                add_reference(table_name, :account, foreign_key: { to_table: table_name_account }, null: false)
            end
        end
    end
end
