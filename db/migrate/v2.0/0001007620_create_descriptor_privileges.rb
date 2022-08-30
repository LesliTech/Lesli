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

class CreateDescriptorPrivileges < ActiveRecord::Migration[7.0]
    def change
        create_table :descriptor_privileges do |t|
            t.string    :controller 
            t.string    :action
            t.string    :form
            t.datetime  :deleted_at, index: true
            t.timestamps
        end
        add_reference :descriptor_privileges, :descriptors, foreign_key:true
    end
end
