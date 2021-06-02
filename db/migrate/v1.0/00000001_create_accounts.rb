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

class CreateAccounts < ActiveRecord::Migration[5.2]
    def change
        create_table :accounts do |t|
            
            # account status
            t.integer   :status

            # company information
            t.string    :company_name
            t.string    :company_name_legal
            t.string    :company_tag_line

            # location
            t.integer   :country
            t.string    :address
            t.string    :region

            # contact details
            t.string    :website
            t.string    :phone_number_1
            t.string    :phone_number_2
            t.string    :phone_number_3
            t.string    :phone_number_4
            t.string    :public_email

            # social media
            t.string    :github
            t.string    :twitter
            t.string    :youtube
            t.string    :linkedin
            t.string    :facebook

            t.timestamps
            
        end
    end
end
