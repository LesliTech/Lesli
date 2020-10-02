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

class CreateAccountIntegrations < ActiveRecord::Migration[6.0]
    def change
        create_table :account_integrations do |t|
            t.string :name
            t.string :status
            #t.string :access_uuid
            t.string :access_token
            t.datetime :last_used_at
            t.datetime :expires_at
            t.timestamps
        end
        #add_reference :account_integrations, :roles, foreign_key: true
        add_reference :account_integrations, :users, foreign_key: true
        add_reference :account_integrations, :accounts, foreign_key: true
    end
end
