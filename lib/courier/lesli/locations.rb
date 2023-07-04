=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
