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
                        .select(:id, :title, :description, :time_start, :time_end, :location, :url, :event_type, :public, :user_main_id, :users_id, :event_date)
                        .joins(:detail)
                        .where("cloud_driver_events.model_id = ? AND cloud_driver_events.model_type = ?", model_id, model_type)
                
                events = events.where("cloud_driver_event_details.event_type = ? ", query[:condition][:type]) unless query[:condition].nil?
                events = events.page(query[:pagination][:page]).per(query[:pagination][:perPage])
                
                # If the order column is time_start, we order by event date first, in case the time is not set and 'time_start' is null
                events = events.order("event_date #{query[:pagination][:order]}") if query[:pagination][:orderColumn] == "time_start"
                events = events.order("#{query[:pagination][:orderColumn]} #{query[:pagination][:order]} NULLS LAST")

                events_count = events.total_count

                events = events.map do |event|
                    organizer = event.user_main
                    {
                        id: event.id, 
                        title: event.title, 
                        description: event.description,
                        time_start_raw: event.time_start,
                        time_end_raw: event.time_end,
                        event_date_raw: event.event_date,
                        time_start: LC::Date.to_string_datetime(event.time_start),
                        time_end: LC::Date.to_string_datetime(event.time_end),
                        event_date: LC::Date.to_string(event.event_date),
                        location: event.location,
                        event_type: event.event_type,
                        editable: event.is_editable_by?(current_user),
                        public: event.public,
                        organizer: {
                            id: organizer.id,
                            email: organizer.email,
                            name: organizer.full_name
                        }
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
