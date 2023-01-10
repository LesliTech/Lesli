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

class AlterUserRequests < ActiveRecord::Migration[7.0]
    def change

        # We must delete the never used extension table
        # IMPORTANT: This statement must be deleted one the migration was executed :) 
        if ActiveRecord::Base.connection.table_exists? 'user_requests_ext'
            drop_table :user_requests_ext
        end

        remove_column user_requests, :request_agent

        add_column :user_requests, :request_count, :integer

        add_index(:user_requests, [:request_controller, :request_action, :request_format, :users_id, :user_sessions_id], unique: true, name: 'user_requests_index')
    end
end
