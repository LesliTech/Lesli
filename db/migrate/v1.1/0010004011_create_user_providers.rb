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

class CreateUserProviders < ActiveRecord::Migration[6.1]
    def change
        create_table :user_providers do |t|
            t.string :provider
            t.string :uid

            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :user_providers, :users, foreign_key: true
    end
end
