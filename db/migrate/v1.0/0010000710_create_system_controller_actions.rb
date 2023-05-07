=begin

Copyright (c) 2021, all rights reserved.

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

class CreateSystemControllerActions < ActiveRecord::Migration[6.1]
    def change
        create_table :system_controller_actions do |t|
            t.string :name
            t.datetime :deleted_at, index: true
            t.timestamps
        end

        add_reference :system_controller_actions, :system_controllers, foreign_key: true
    end
end
