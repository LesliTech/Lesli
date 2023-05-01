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

class CreateUserRequests < ActiveRecord::Migration[6.0]
    def change
        create_table :user_requests do |t|
            t.string    :request_controller
            t.string    :request_action
            t.string    :request_method
            t.string    :request_format
            t.string    :request_url
            t.integer   :request_count

            t.datetime  :deleted_at, index: true
            t.timestamps
        end

        add_reference(:user_requests, :users, foreign_key: true)
        add_reference(:user_requests, :user_sessions, foreign_key: true)

        add_index(:user_requests, [:request_controller, :request_action, :request_format, :users_id, :user_sessions_id], unique: true, name: "user_requests_index")
    end
end
