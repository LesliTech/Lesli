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

        class Locations

            def self.verify_location(current_user, location_id, location_name, level)
                return current_user.account.locations.find_by(id: location_id).id if location_id

                if location_name && !location_name.empty? && !location_id
                    parent_location = current_user.account.locations.find_by(level: "empty")
                    begin

                        location = current_user.account.locations.create!(
                            name: location_name,
                            level: level,
                            parent_location: parent_location
                        )
        
                        return location.id
                    rescue ActiveRecord::RecordNotUnique
                        return current_user.account.locations.find_by(
                            name: location_name,
                            level: level,
                            parent_location: parent_location
                        ).id
                    end
                    
                else
                    return nil
                end
            end

            def self.find_or_create_by_name(current_user, location_name, level)
                if location_name && !location_name.empty?
                    location = current_user.account.locations.find_by(
                        name: location_name,
                        level: level
                    )
                    return location.id if location

                    parent_location = current_user.account.locations.find_by(level: "empty")
                    location = current_user.account.locations.create!(
                        name: location_name,
                        level: level,
                        parent_location: parent_location
                    )
                    return location.id
                else
                    return nil
                end
            end

        end

    end
    
end
