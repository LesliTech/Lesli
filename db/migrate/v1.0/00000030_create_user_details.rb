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

class CreateUserDetails < ActiveRecord::Migration[6.0]
    def change
        create_table :user_details do |t|

            t.string :title
            t.string :salutation

            t.string :first_name
            t.string :last_name
            t.string :telephone
            t.string :address

            t.integer :work_city
            t.integer :work_region
            t.integer :work_address

            t.datetime :deleted_at, index: true            
            t.timestamps
            
        end
        add_reference :user_details, :users, foreign_key: true
    end
end
