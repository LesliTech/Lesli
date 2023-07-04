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
    module Driver
        class Event::Attendant

            def self.index(current_user, query, events_id)
                return {} unless defined? CloudDriver

                event = Courier::Driver::Event.find(current_user, events_id)

                event.attendant_list
            end

            def self.create(current_user, events_id, event_attendant_params)
                return nil unless defined? CloudDriver

                # Using the CloudDriver services to create the event attendant
                CloudDriver::Event::AttendantServices.create(current_user, events_id, event_attendant_params)
            end

            def self.destroy(current_user, events_id, event_attendants_id)
                return nil unless defined? CloudDriver

                # Using the CloudDriver services to destroy the event attendant
                CloudDriver::Event::AttendantServices.destroy(current_user, events_id, event_attendants_id)
            end

        end
    end
end
