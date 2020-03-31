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

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
module Courier
    module Core
        class Locations
            def self.verify_location(current_user, location_city_id, location_city_name, level)
                return current_user.account.locations.find_by(id: location_city_id).id if location_city_id

                if location_city_name && ! location_city_id
                    begin
                        parent_location = current_user.account.locations.find_by(level: "empty")

                        location = current_user.account.locations.create!(
                            name: location_city_name,
                            level: level,
                            parent_location: parent_location
                        )
        
                        return location.id
                    rescue ActiveRecord::RecordNotUnique
                        return current_user.account.locations.find_by(
                            name: location_city_name,
                            level: level,
                            parent_location: parent_location
                        ).id
                    end
                    
                else
                    return nil
                end
            end
        end
    end
end
