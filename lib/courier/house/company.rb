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
    module House
        class Company

            def self.list(current_user, query=nil)
                return [] unless defined? CloudHouse
                CloudHouse::Company.index(current_user, query)
            end

            def self.show(current_user, query=nil)
                return [] unless defined? CloudHouse
                CloudHouse::Company.find(query['id']).show()
            end

            def self.create_activity(activity_params)
                return unless defined? CloudHouse

                activity = CloudHouse::Company::Activity.create(activity_params)
            end

        end
    end
end
