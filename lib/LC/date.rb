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

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

# · Lesli Core
# · LC::Date.to_string()
# · LC::Date.to_string()
# · Lesli::Date.to_string()
# · Lesli::Date.to_string()
module LC

    class Date

        # set timezone and date formats here 

        # NOTE: Do not modify formats here,
        # if you need a different date format you should change it in the settings

        @time_zone = "Europe/Berlin"
        @string_format = "%Y.%m.%d"

        @string_time = "%H:%M"
        @string_datetime_format = "%Y.%m.%d %H:%M"
        @string_words_format = "%a, %B %d, %Y"

        def self.to_string datetime_object
            zone = ActiveSupport::TimeZone.new(@time_zone)
            datetime_object.in_time_zone(zone).strftime(@string_format)
        end

        def self.to_string_datetime datetime_object
            zone = ActiveSupport::TimeZone.new(@time_zone)
            datetime_object.in_time_zone(zone).strftime(@string_datetime_format)
        end

        def self.to_string_time datetime_object
            zone = ActiveSupport::TimeZone.new(@time_zone)
            datetime_object.in_time_zone(zone).strftime(@string_time)
        end

        def self.to_string_datetime_words datetime_object
            zone = ActiveSupport::TimeZone.new(@time_zone)
            datetime_object.in_time_zone(zone).strftime(@string_datetime_format)
        end

        def self.today_at_midnight
            zone = ActiveSupport::TimeZone.new(@time_zone)
            return Time.current.in_time_zone(zone).beginning_of_day
        end

        def self.tomorrow_at_midnight
            zone = ActiveSupport::TimeZone.new(time_zone)
            return Time.current.in_time_zone(zone).beginning_of_day + 1.day
        end

        def self.now
            time_zone="Europe/Berlin"
            zone = ActiveSupport::TimeZone.new(time_zone)
            return Time.current.in_time_zone(zone)
        end

        def self.distance_to_words

            zone = ActiveSupport::TimeZone.new(time_zone)

            time_from = time_from.in_time_zone(zone)
            time_to = time_to.in_time_zone(zone)

            distance_in_seconds = (time_to - time_from).round
            distance_in_minutes = (distance_in_seconds / 60.0).round
            distance_in_hours= (distance_in_minutes / 60.0).round
            distance_in_days = (distance_in_hours / 24.0).round
            distance_in_weeks = (distance_in_days / 7.0).round
            distance_in_months = (distance_in_days / 30).round

            # return distance in days
            return "#{distance_in_days} day ago" if distance_in_days == 1
            return "#{distance_in_days} days ago" if distance_in_days > 1

            # return distance in hours
            return "#{distance_in_hours} hour ago" if distance_in_hours == 1
            return "#{distance_in_hours} hours ago" if distance_in_hours > 1

            # return distance in minutes
            return "#{distance_in_minutes} minute ago" if distance_in_minutes == 1
            return "#{distance_in_minutes} minutes ago" if distance_in_minutes > 1

            # return distance in minutes
            return "#{distance_in_seconds} second ago" if distance_in_seconds == 1
            return "#{distance_in_seconds} seconds ago" if distance_in_seconds > 1

            # return generic distance
            return "some time ago"

        end

    end

end
