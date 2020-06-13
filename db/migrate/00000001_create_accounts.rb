=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

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
            t.string    :address

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
