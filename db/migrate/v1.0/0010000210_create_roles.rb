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
            t.string    :code
            t.boolean   :active

            # redirect users to path after login
            t.string    :path_default

            # allow users to access resources only inside the :path_default 
            t.boolean   :path_limited
            
            # allow users to work only with data created or assigned to them
            t.boolean   :isolated, default: false

            # role hierarchy
            t.integer   :object_level_permission, default: 10

            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :roles, :accounts, foreign_key:true
    end
end
