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
module Courier

    module Lock

        class Role

            def self.privilege(current_user, controller, grant)
                privilege = current_user.account.lock.users
                            .find_by(users_id: current_user.id)
                            .role
                            .privileges
                            .where("grant_object_name = ? and #{grant} = ?", controller, true)
                            .first
            end
        end

    end
    
end
