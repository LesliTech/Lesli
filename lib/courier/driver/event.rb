=begin

Copyright (c) 2022, all rights reserved.

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
        class Event

            def self.create(current_user, event_params, calendar=nil)
                return nil unless defined? CloudDriver

                # Using the EventServices to create the event
                CloudDriver::EventServices.create(current_user, event_params, calendar)
            end

            def self.find(current_user, events_id)
                return nil unless defined? CloudDriver

                # Using the EventServices to find the event
                event_response = CloudDriver::EventServices.find(current_user, events_id)

                return event_response.payload if event_response.successful?
                return nil
            end

            def self.update(current_user, events_id, event_params)
                return nil unless defined? CloudDriver

                # Using the EventServices to update the event
                CloudDriver::EventServices.update(current_user, events_id, event_params)
            end

            def self.destroy(current_user, events_id)
                return nil unless defined? CloudDriver

                # Using the EventServices to destroy the event
                CloudDriver::EventServices.destroy(current_user, events_id)
            end

            def self.find_integration_event(current_user, external_uid, source_code)
                return nil unless defined? CloudDriver

                # Looking for the calendar
                calendar = CloudDriver::Calendar.find_by(
                    user_main: current_user,
                    user_creator: current_user,
                    source_code: source_code,
                )

                # Looking for the event on the calendar
                event = CloudDriver::Event.find_by(
                    external_uid: external_uid,
                    calendar: calendar
                )

                event
            end

            def self.by_model(model_type, model_id, current_user, query)
                return [] unless defined? CloudDriver

                events = current_user.account.driver.events.select(
                    :id,
                    :title,
                    :description,
                    :time_start,
                    :time_end,
                    :location,
                    :url,
                    :public,
                    :user_main_id,
                    :users_id,
                    :event_date,
                    "cloud_driver_catalog_event_types.name as event_type"
                ).joins(
                    :detail
                ).left_joins(
                    :type
                ).where(
                    "cloud_driver_events.model_id = ? AND cloud_driver_events.model_type = ?", model_id, model_type
                )

                events = events.where("cloud_driver_catalog_event_types.name = ? ", query[:condition][:type]) unless query[:condition].nil?
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

            def self.with_deadline(current_user, query, calendar)
                return [] unless defined? CloudDriver

                CloudDriver::Event.with_deadline(current_user, query, calendar)
            end
        end
    end
end
