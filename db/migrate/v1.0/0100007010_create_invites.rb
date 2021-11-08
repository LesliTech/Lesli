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

class CreateInvites < ActiveRecord::Migration[6.1]
    def change
        create_table :invites do |t|
            t.string :email, null: false
            t.string :full_name
            t.string :telephone
            t.text   :note

            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :invites, :accounts, foreign_key: true
    end
end
