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

class CreateRoles < ActiveRecord::Migration[6.0]
    def change
        create_table :roles do |t|
            t.string    :name
            t.boolean   :active
            t.string    :default_path
            t.boolean   :only_my_data, default: false
            t.integer   :object_level_permission, default: 10

            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :roles, :accounts, foreign_key:true
    end
end
