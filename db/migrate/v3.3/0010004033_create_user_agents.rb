=begin

Copyright (c) 2023, all rights reserved.

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

class CreateUserAgents < ActiveRecord::Migration[7.0]
    def change
        create_table :user_agents do |t|
            t.string  :platform
            t.string  :os
            t.string  :browser
            t.string  :version
            t.integer :count
            t.timestamps
        end

        add_reference :user_agents, :users, foreign_key: true
        add_reference :user_agents, :user_sessions, foreign_key: true

        add_index(:user_agents, [:platform, :os, :browser, :version, :users_id, :user_sessions_id], unique: true, name: 'user_agents_index')
    end
end
