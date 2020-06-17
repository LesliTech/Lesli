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

class CreateRolesPrivilegeDefaults < ActiveRecord::Migration[6.0]
    def change
        create_table :roles_privilege_defaults do |t|
            # module/namespace/[controller/model]
            t.string  :grant_object

            t.boolean :grant_index,     default: false

            t.boolean :grant_edit,      default: false
            t.boolean :grant_show,      default: false
            t.boolean :grant_new,       default: false

            t.boolean :grant_create,    default: false
            t.boolean :grant_update,    default: false
            t.boolean :grant_destroy,   default: false

            t.boolean :grant_options,   default: false
            t.boolean :grant_default,   default: false
            t.boolean :grant_search,   default: false
            t.boolean :grant_empty,     default: false

            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :roles_privilege_defaults, :role_privileges, foreign_key:true
    end
end
