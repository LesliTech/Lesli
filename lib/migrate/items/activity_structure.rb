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
    module Items
        module ActivityStructure
            def create_table_lesli_item_activities_10(engine)

                table_name, foreign_key = table_name_for_item(engine, :activities)

                create_table table_name do |t|

                    # Contenido
                    t.string :description

                    # Tipo principal del registro
                    t.string :activity_type, null: false, default: :activity

                    # Subtipo para actividades
                    t.string :activity_code

                    # Metadatos opcionales (JSON)
                    t.json :metadata, default: {}

                    # Polymorphic target
                    t.string  :subject_type, null: false
                    t.bigint  :subject_id,   null: false

                    t.timestamps
                    t.datetime :deleted_at, index: true
                end

                add_reference(table_name, :user, foreign_key: { to_table: :lesli_users }) 
                add_reference(table_name, :account, foreign_key: { to_table: "#{engine}_accounts".to_sym })
                add_index(table_name, [:account_id, :subject_type, :subject_id], name: "#{table_name}_activities_type_id")
            end
        end
    end
end
