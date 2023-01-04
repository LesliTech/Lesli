=begin

Copyright (c) 2023, all rights reserved.

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
