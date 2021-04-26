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
    module Driver
        class Calendar

            def self.index(current_user, query, calendar)
                return nil unless defined? CloudDriver

                calendar_data = {
                    id: calendar.id,
                    name: calendar.name,
                    driver_events: [],
                    focus_tasks: [],
                    help_tickets: []
                }

                query_text = nil
                if (query[:filters][:query]) && (! query[:filters][:query].empty?)
                    query_text = query[:filters][:query].downcase.split(" ")
                end

                # events from CloudDriver
                # This query is diferent because, by default, driver events are included
                unless query[:filters][:include] && query[:filters][:include][:driver_events].to_s.downcase == "false"        

                    # selection all my events in one query
                    driver_events = calendar.events.joins(:detail)
                    .joins("inner join cloud_driver_event_attendants CDEA on CDEA.cloud_driver_events_id = cloud_driver_events.id")
                    .select(
                        :users_id,
                        :user_main_id,
                        :id, 
                        :title, 
                        :description, 
                        "event_date as date",
                        "time_start as start", 
                        "time_end as end", 
                        :location,
                        :model_type,
                        :url,
                        :event_type,
                        "true as \"is_attendant\"",
                        "false as \"editable\"",
                        "CONCAT('cloud_driver_event',' ', LOWER(SPLIT_PART(cloud_driver_events.model_type, '::', 2)))  as \"classNames\"",
                        LC::Date2.new.date_time.db_column("event_date")
                    )
                    .where("
                        CDEA.users_id = :user 
                        or cloud_driver_events.user_main_id = :user 
                        or cloud_driver_events.users_id = :user
                        or cloud_driver_event_details.public = true", { user: current_user.id })
                    .where("cloud_driver_event_details.event_date >= ?", query[:filters][:start_date])
                    .where("cloud_driver_event_details.event_date <= ? ", query[:filters][:end_date])
                    .order("date")
            
                    driver_events.each do |event|
                        event[:editable] = event.is_editable_by?(current_user)
                    end

                    driver_events = self.filter_records_by_text(driver_events, query_text, fields: ["title", "description", "location"])

                    calendar_data[:driver_events] = driver_events
                end

                # tasks from CloudFocus
                if (defined? CloudFocus) && (query[:filters][:include]) && (query[:filters][:include][:focus_tasks].to_s.downcase == "true")
                    focus_tasks  = Courier::Focus::Task.with_deadline(current_user, query)
                    focus_tasks = self.filter_records_by_text(focus_tasks, query_text)

                    focus_tasks = focus_tasks.map do |task|
                        {
                            id: task[:id],
                            title: task[:title],
                            description: task[:description],
                            date: task[:deadline],
                            start: task[:deadline],
                            end: task[:deadline],
                            event_date_string: task[:deadline_string],
                            classNames: ["cloud_focus_tasks"]
                        }
                    end

                    calendar_data[:focus_tasks] = focus_tasks
                end

                # tickets from CloudHelp
                if (defined? CloudHelp) && (query[:filters][:include]) && (query[:filters][:include][:help_tickets].to_s.downcase == "true")
                    help_tickets  = Courier::Help::Ticket.with_deadline(current_user, query)
                    help_tickets = self.filter_records_by_text(help_tickets, query_text, fields: ["subject", "description"])
                    
                    help_tickets = help_tickets.map do |ticket|
                        {
                            id: ticket[:id],
                            title: ticket[:subject],
                            description: ticket[:description],
                            date: ticket[:deadline],
                            start: ticket[:deadline],
                            end: ticket[:deadline],
                            event_date_string: ticket[:deadline_string],
                            classNames: ["cloud_help_tickets"]
                        }
                    end

                    calendar_data[:help_tickets] = help_tickets
                end

                calendar_data
            end

            def self.events_register_for(
                current_user, reference_name, reference_id, 
                title:, description:nil, time_start:nil, time_end:nil, location:nil, url:nil
            )
                return unless defined? CloudDriver
                current_user.account.driver.calendars.default.events.create({
                    reference_name: reference_name, 
                    reference_id: reference_id,
                    detail_attributes: {
                        title: title,
                        description: description,
                        time_start: time_start || Time.now,
                        time_end: time_end || Time.now,
                        location: location,
                        url: url
                    }
                })
            end

            def self.events_update_for(
                current_user, reference_name, reference_id, 
                title:, description:nil, time_start:nil, time_end:nil, location:nil, url:nil
            )
                return unless defined? CloudDriver
                events = current_user.account.driver.calendars.default.events.where(reference_name: reference_name, reference_id: reference_id)

                events.each do |event|
                    event.detail.title = title unless title.blank?
                    event.detail.description = description unless description.blank?
                    event.detail.time_start = time_start unless time_start.blank?
                    event.detail.time_end = time_end unless time_end.blank?
                    event.detail.location = location unless location.blank?
                    event.detail.url = url unless url.blank?
                    event.save!
                end

            end
            
            def self.events_new(current_user, title:, description:nil, time_start:nil, time_end:nil, location:nil, url:nil)
                return unless defined? CloudDriver
                current_user.account.driver.calendars.default.events.create({
                    detail_attributes: {
                        title: title,
                        description: description,
                        time_start: time_start || Time.now,
                        time_end: time_end || Time.now,
                        location: location,
                        url: url
                    }
                })
            end

            def self.events(current_user)
                return unless defined? CloudDriver
                current_user.account.driver.calendars.default.events
                .joins(:detail)
                .select(:id, :title, :description, :event_date, :time_start, :time_end, :location, :url, :event_type, :public, :model_type)
            end

            protected

            def self.filter_records_by_text(records, query_text, fields: ["title", "description"])

                if query_text
                    query_text.each do |query_word|
                        sql = []
                        fields.each do |field|
                            sql.push("lower(#{field}) like '%#{query_word}%'")
                        end
        
                        records = records.where(sql.join(" or "))
                    end
                end

                return records
            end
        end
    end
end
