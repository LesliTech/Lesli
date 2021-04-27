=begin

Copyright (c) 2021, all rights reserved.

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
            
            # @return A hash that contains an array in each key. These arrays contain events, tasks and tickets
            #     standarized to be displayed within the calendar
            # @param current_user [User] The user that made this request
            # @param query [Hash] Query information that contains wether all 3 kinkds of records should be included,
            #     and text used to filter the results
            # @description This method calls the '.with_deadline' method from the courier of all models that will be
            #     displayed. Currently CloudDriver::Event, CloudFocus::Task and CloudHelp::Ticket are the ones included.
            #     Each courier method should call the '.with_deadline' method of the specific engine. The results are
            #     then standarized and returned to the fronted to be dispayed
            # @example
            #     current_user = User.find(2)
            #     query = {
            #         filters: {
            #             include: {
            #                 focus_tasks: false,
            #                 help_tickets: true
            #             },
            #             start_date: '2020-01-01 00:00:00',
            #             end_date: '2020-12-31 11:59:00',
            #             query: 'notar'
            #         }
            #     }
            #     puts Courier::Driver::Calendar.show(current_user, query, current_user.account.driver.calendars.default)
            #     # This will display something like
            #     # {
            #     #     id: 1,
            #     #     name: 'default',
            #     #     driver_event: [...],
            #     #     focus_tasks: [],
            #     #     help_tickets: []
            #     # }
            def self.show(current_user, query, calendar)
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
                # This condition is diferent because, by default, driver events are included
                unless query[:filters][:include] && query[:filters][:include][:driver_events].to_s.downcase == "false"
                    driver_events = Courier::Driver::Event.with_deadline(current_user, query, calendar)
                    driver_events = self.filter_records_by_text(driver_events, query_text, fields: ["title", "description", "location"])

                    driver_events = driver_events.map do |event|
                        {
                            id: event[:id],
                            title: event[:title],
                            description: event[:description],
                            date: event[:event_date],
                            start: event[:time_start],
                            end: event[:time_end] + 1.second, # The calendar will crash if start and end dates are the same
                            classNames: ["cloud_driver_events"]
                        }
                    end
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
                            end: task[:deadline] + 1.second, # The calendar will crash if start and end dates are the same
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
                            end: ticket[:deadline] + 1.second, # The calendar will crash if start and end dates are the same
                            classNames: ["cloud_help_tickets"]
                        }
                    end
                    calendar_data[:help_tickets] = help_tickets
                end

                calendar_data
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
