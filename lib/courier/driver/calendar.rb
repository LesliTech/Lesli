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
            def self.show(current_user, query, calendars_id=nil)
                return nil unless defined? CloudDriver

                calendar = nil

                # Getting the calendars accessible by the current user
                calendars = current_user.account.driver.calendars.where(
                    user_main: current_user
                ).or(
                    current_user.account.driver.calendars.where(user_main: nil)
                )

                # Looking for the calendar with the given id
                calendar = calendars.find_by_id(calendars_id) unless calendars_id.blank?

                # Using default account calendar if no calendar was found
                calendar = current_user.account.driver.calendars.default(current_user) unless calendar

                # Showing the calendar
                calendar.show(current_user, query)
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

        end
    end
end
