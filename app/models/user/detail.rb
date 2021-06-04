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

class User::Detail < ApplicationRecord
    belongs_to :user, foreign_key: "users_id"
    after_update :change_after_update

    enum salutation: {
        mr: 'mr',
        mrs: 'mrs'
    }

    def change_after_update
        if saved_change_to_first_name? || saved_change_to_last_name?
            if defined? CloudOne

                data = {
                    full_name: self.user.full_name
                }

                CloudOne::Firebase::User.update_data(self, data)

            end
        end
    end

end
