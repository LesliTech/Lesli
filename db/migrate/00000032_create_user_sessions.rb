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

class CreateUserSessions < ActiveRecord::Migration[6.0]
    def change
        create_table :user_sessions do |t|

            t.inet   :user_remote       # IPv4 and IPv6 hosts and networks
            t.string :user_agent    
            t.string :user_uuid         # unique user identifier

            t.string :session_uuid      # unique session identifier
            t.string :session_token
            t.string :session_source    # session created for/with

            t.integer  :usage_count                     # total number of interactions 
            t.datetime :last_used_at                    # last datetime token was used
            t.datetime :expiration_at, index: true      # auto-expire session at
            t.datetime :deleted_at, index: true

            t.timestamps
        end
        add_reference :user_sessions, :users, foreign_key: true
    end
end
