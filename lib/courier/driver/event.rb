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

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module Courier
    module Driver
        class Event

            def self.by_model(model_type, model_id, current_user, query)
                return [] unless defined? CloudFocus
                events = current_user.account.driver.events
                        .select(:id, :title, :description, :time_start, :time_end, :location, :url, :event_type, :public, :organizer_id, :users_id)
                        .joins(:detail)
                        .where("cloud_driver_events.model_id = ? AND cloud_driver_events.model_type = ?", model_id, model_type)
                
                events = events.where("cloud_driver_event_details.event_type = ? ", query[:condition][:type]) unless query[:condition].nil?
                events = events.order("cloud_driver_events.created_at")
                events = events.page(query[:pagination][:page]).per(query[:pagination][:perPage])

                events_count = events.total_count

                events = events.map do |event|
                    {
                        id: event.id, 
                        title: event.title, 
                        description: event.description,
                        time_start: Courier::Core::Date.to_string_full(event.time_start),
                        time_end: Courier::Core::Date.to_string_full(event.time_end),
                        location: event.location,
                        event_type: event.event_type,
                        public: event.public,
                        organizer: Courier::Core::Users.get(event.organizer_id)
                    }
                end
    
                {
                    events: events,
                    events_count: events_count
                }
            end
        end
    end
end
