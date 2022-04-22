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

class CreateAccountCronos < ActiveRecord::Migration[6.1]
    def change
        create_table :account_cronos do |t|
            t.string  :name
            t.string  :description
            t.integer :status

            t.string  :engine
            t.string  :rake         # The rake command that will execute the task

            t.integer :minute
            t.integer :hour
            t.integer :day_of_month
            t.integer :month
            t.integer :day_of_week

            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :account_cronos, :accounts, foreign_key:true
        add_reference :account_cronos, :users, foreign_key:true
    end
end
