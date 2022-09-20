=begin

Copyright (c) 2022, all rights reserved.

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

class CreateRoleDescribers < ActiveRecord::Migration[7.0]
    def change
        create_table :role_describers do |t|
            t.timestamps
            t.datetime :deleted_at, index: true
        end
        add_reference :role_describers, :roles, foreign_key: true
        add_reference :role_describers, :descriptors, foreign_key: true
        add_reference :role_describers, :user, foreign_key: true
    end
end
