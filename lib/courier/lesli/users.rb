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

    module Lesli

        class Users

            def self.index current_user, query, params
                User.index current_user, query, params
            end

            def self.list()
                :User.list
            end

            def self.get(id)
                return ::User.find(id).show
            end

            def self.get_by_email(email)
                return ::User.find_by_email(email).show
            end

        end

    end
    
end
