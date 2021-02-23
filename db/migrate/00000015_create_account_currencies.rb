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
class CreateAccountCurrencies < ActiveRecord::Migration[6.1]
    def change
        create_table :account_currencies do |t|
            t.string        :name
            t.string        :symbol
            t.string        :country_alpha_3

            # Main user
            t.bigint        :user_main_id      
            
            # Acts as paranoid
            t.datetime :deleted_at, index: true
            
            t.timestamps
        end
        
        add_reference   :account_currencies, :users,    foreign_key: true
        add_reference   :account_currencies, :accounts, foreign_key: true
        add_foreign_key :account_currencies, :users,    column: :user_main_id

    end
end
