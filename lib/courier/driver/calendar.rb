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
        class Calendar

            # @return [Array] An array of calendars for the given user.
            def self.index(current_user, query)
                return [] unless defined? CloudDriver
                CloudDriver::CalendarService.new(current_user).index(query)
            end

            # @return [Hash] A hash that contains an array in each key. These arrays contain events, tasks and tickets
            #     standarized to be displayed within the calendar
            def self.show(current_user, query, calendars_id=nil)
                return nil unless defined? CloudDriver

                # Looking for the calendar
                calendar = CloudDriver::CalendarService.new(current_user).find(calendars_id)

                # Showing the calendar
                calendar.show(query)
            end

            # @return [CloudDriver::Calendar] Creates and returns a new calendar for the given user with the given name, source code and default status
            def self.create_user_calendar(current_user, name: nil, source_code: 'lesli', default: false)
                return nil unless defined? CloudDriver
                LC::Debug.deprecation("Courier::Driver::Calendar.create_user_calendar is deprecated. Use Courier::Driver::Calendar.create instead.")

                calendar = CloudDriver::CalendarService.new(current_user).create({
                    name: name,
                    default: default,
                    source_code: source_code
                })

                calendar.result
            end

            def self.create(current_user, params)
                return nil unless defined? CloudDriver
                CloudDriver::CalendarService.new(current_user).create(params)
            end

            # @return [CloudDriver::Calendar] Returns an instance of the default calendar for the current user.
            #   If source code is provided and default, it will be evaluated and the result will be returned.
            def self.get_user_calendar(current_user, source_code: 'lesli', default: false)
                return nil unless defined? CloudDriver
                LC::Debug.deprecation("Courier::Driver::Calendar.get_user_calendar is deprecated. Use Courier::Driver::Calendar.find_by_source instead.")

                calendar = CloudDriver::CalendarService.new(current_user).find_by_source(source_code, default: default)
                calendar.result
            end

            def self.find_by_source(current_user, source_code: 'lesli', default: false)
                return nil unless defined? CloudDriver

                calendar = CloudDriver::CalendarService.new(current_user).find_by_source(source_code, default: default)
            end

            # @return [CloudDriver::Calendar] Returns an instance of a calendar with the given id.
            def self.find_by_id(current_user, id)
                return nil unless defined? CloudDriver
                LC::Debug.deprecation("Courier::Driver::Calendar.find_by_id is deprecated. Use Courier::Driver::Calendar.find instead.")

                calendar = CloudDriver::CalendarService.new(current_user).find(id)
                calendar.result
            end

            def self.find(current_user, id)
                return nil unless defined? CloudDriver
                CloudDriver::CalendarService.new(current_user).find(id)
            end

            def self.default_calendar(current_user)
                return nil unless defined? CloudDriver
                CloudDriver::CalendarService.new(current_user).default_calendar
            end

        end
    end
end
