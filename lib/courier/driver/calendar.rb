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
        class Calendar

            # @return [Array] An array of calendars for the given user.
            def self.index(current_user, query)
                return [] unless defined? CloudDriver

                CloudDriver::Calendar.index(current_user, query)
            end

            # @return [Hash] A hash that contains an array in each key. These arrays contain events, tasks and tickets
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
            def self.show(current_user, query, calendars_id=nil)
                return nil unless defined? CloudDriver

                calendar = nil

                # Looking for the calendar with the given id
                calendar = current_user.account.driver.calendars.find_by_id(calendars_id) unless calendars_id.blank?

                # Using default account calendar if no calendar was found
                calendar = current_user.account.driver.calendars.default(current_user) unless calendar

                # Calendar data
                calendar_data = {
                    id: calendar.id,
                    name: calendar.detail.name,
                    users_id: calendar.user_main_id,
                    user_name: calendar.user_main_id ? calendar.user_main.full_name : nil,
                    events: [],
                    driver_events: [],
                    focus_tasks: [],
                    help_tickets: [],
                }

                # If filter dates not provided, force use current month
                if query[:filters][:start_date].blank? or query[:filters][:end_date].blank?
                    query[:filters][:start_date] = query[:filters][:start_date] || Time.now.beginning_of_month.to_s
                    query[:filters][:end_date] = query[:filters][:end_date] || Time.parse(query[:filters][:start_date]).end_of_month.to_s
                end

                search_text = nil

                # Setting search text
                if (query[:filters][:search]) && (! query[:filters][:search].empty?)
                    search_text = query[:filters][:search].downcase.split(" ")
                end

                # Getting calendar events
                calendar_events = Courier::Driver::Event.with_deadline(current_user, query, calendar)
                calendar_events = self.filter_records_by_text(calendar_events, search_text, fields: ["title", "description", "location"])
                calendar_data[:events] = calendar_events

                # events from CloudDriver
                # This condition is diferent because, by default, driver events are included
                unless query[:filters][:include] && query[:filters][:include][:driver_events].to_s.downcase == "false"
                    driver_events = calendar_events.map do |event|
                        {
                            id: event[:id],
                            title: event[:title],
                            description: event[:description],
                            date: event[:date],
                            start: event[:start],
                            end: event[:end],
                            is_attendant: event[:is_attendant],
                            event_type: event[:event_type],
                            classNames: ["cloud_driver_events"],
                        }
                    end

                    calendar_data[:driver_events] = driver_events
                end

                # tasks from CloudFocus
                if (defined? CloudFocus) && (query[:filters][:include]) && (query[:filters][:include][:focus_tasks].to_s.downcase == "true")
                    focus_tasks  = Courier::Focus::Task.with_deadline(current_user, query)
                    focus_tasks = self.filter_records_by_text(focus_tasks, search_text)

                    focus_tasks = focus_tasks.map do |task|
                        {
                            id: task[:id],
                            title: task[:title],
                            description: task[:description],
                            date: task[:deadline],
                            start: task[:deadline],
                            end: task[:deadline] ? task[:deadline] + 1.second : nil, # The calendar will crash if start and end dates are the same
                            classNames: ["cloud_focus_tasks"]
                        }
                    end

                    calendar_data[:focus_tasks] = focus_tasks
                end

                # tickets from CloudHelp
                if (defined? CloudHelp) && (query[:filters][:include]) && (query[:filters][:include][:help_tickets].to_s.downcase == "true")
                    help_tickets  = Courier::Help::Ticket.with_deadline(current_user, query)
                    help_tickets = self.filter_records_by_text(help_tickets, search_text, fields: ["subject", "description"])

                    help_tickets = help_tickets.map do |ticket|
                        {
                            id: ticket[:id],
                            title: ticket[:subject],
                            description: ticket[:description],
                            date: ticket[:deadline],
                            start: ticket[:deadline],
                            end: ticket[:deadline] ? ticket[:deadline] + 1.second : nil, # The calendar will crash if start and end dates are the same
                            classNames: ["cloud_help_tickets"]
                        }
                    end

                    calendar_data[:help_tickets] = help_tickets
                end

                calendar_data
            end

            # @return [CloudDriver::Calendar] Creates and returns a new calendar for the given user with the given name, source code and default status
            def self.create_user_calendar(user, name: nil, source_code: 'lesli', default: false)
                return nil unless defined? CloudDriver

                user.account.driver.calendars.create_with(
                    detail_attributes: {
                        name: name,
                        default: default,
                    }
                ).find_or_create_by!(
                    user_main: user,
                    user_creator: user,
                    source_code: source_code
                )
            end

            # @return [CloudDriver::Calendar] Returns an instance of the default calendar for the current user.
            #   If source code is provided and default, it will be evaluated and the result will be returned.
            def self.get_user_calendar(current_user, source_code: 'lesli', default: false)
                return nil unless defined? CloudDriver

                current_user.account.driver.calendars.eager_load(:detail).find_by(
                    user_main: current_user,
                    user_creator: current_user,
                    source_code: source_code,
                    cloud_driver_calendar_details: {
                        default: default
                    }
                )
            end

            # @return [CloudDriver::Calendar] Returns an instance of a calendar with the given id.
            def self.find_by_id(current_user, id)
                return nil unless defined? CloudDriver

                # Filtering the calendars by the current user calendars and the public calendars
                calendars = current_user.account.driver.calendars.where(
                    user_main: current_user
                ).or(
                    current_user.account.driver.calendars.where(user_main: nil)
                )

                # Getting the calendar
                calendars.find_by_id(id)
            end

            protected

            def self.filter_records_by_text(records, search_text, fields: ["title", "description"])

                if search_text
                    search_text.each do |query_word|
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
