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

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
module Courier

    module Core

        class Date

            def self.to_string datetime_object, format="%Y.%m.%d", time_zone="Europe/Berlin"
                zone = ActiveSupport::TimeZone.new(time_zone)
                datetime_object.in_time_zone(zone).strftime(format)
            end

            def self.to_string_full datetime_object, format="%a, %B %d, %Y", time_zone="Europe/Berlin"
                zone = ActiveSupport::TimeZone.new(time_zone)
                datetime_object.in_time_zone(zone).strftime(format)
            end

            def self.to_string_datetime datetime_object, format="%Y.%m.%d %H:%M", time_zone="Europe/Berlin"
                zone = ActiveSupport::TimeZone.new(time_zone)
                datetime_object.in_time_zone(zone).strftime(format)
            end

            def self.to_string_time datetime_object, format="%H:%M", time_zone="Europe/Berlin"
                zone = ActiveSupport::TimeZone.new(time_zone)
                datetime_object.in_time_zone(zone).strftime(format)
            end

            def self.get_year_difference from_time, to_time, time_zone="Europe/Berlin"
                # We set the same timezone for both Time variables
                zone = ActiveSupport::TimeZone.new(time_zone)
                from_time = from_time.in_time_zone(zone)
                to_time = to_time.in_time_zone(zone)
                
                # We extract years, months, and days
                from_year = from_time.year
                to_year = to_time.year
                from_month = from_time.month
                to_month = to_time.month
                from_day = from_time.day
                to_day = to_time.day

                year_difference = to_year - from_year
                if from_month > to_month
                    return year_difference - 1
                end

                if from_month == to_month
                    if from_day > to_day
                        return year_difference - 1
                    end
                end

                return year_difference
            end

            def self.today_at_midnight time_zone="Europe/Berlin"
                zone = ActiveSupport::TimeZone.new(time_zone)
                return Time.current.in_time_zone(zone).beginning_of_day
            end

            def self.tomorrow_at_midnight time_zone="Europe/Berlin"
                zone = ActiveSupport::TimeZone.new(time_zone)
                return Time.current.in_time_zone(zone).beginning_of_day + 1.day
            end

            def self.now time_zone="Europe/Berlin"
                zone = ActiveSupport::TimeZone.new(time_zone)
                return Time.current.in_time_zone(zone)
            end

            def self.distance_to_words time_from, time_to=Time.now, time_zone="Europe/Berlin"

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

end
