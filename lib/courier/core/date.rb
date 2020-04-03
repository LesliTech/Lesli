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

            def self.to_string datetime_object, format="%Y/%m/%d", time_zone="Europe/Berlin"
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

=begin

            # datetime object
            #@datetime = nil

            #@date_format = nil
            #@date_format_full = nil
            #@date_time_format = nil

            #def initialize(datetime, format="%Y/%m/%d %H:%M")
                # get custom datetime formats from settings in database
                #date_formats = @account
                # catch only string datetimes
            #    if datetime.kind_of? String
            #        datetime = from_string(datetime, format)
            #    end
            #    datetime.strftime(datetime, format)
            #end

            #def to_string
            #end

            def to_string_full
            end

            def from_string(datetime_string, format=nil)
                Date.strptime(datetime_string, format)
            end



            def self.to_string(datetime, format="%Y/%m/%d %H:%M")
                return "" unless datetime
                datetime.strftime(datetime, format)
            end
    
            def self.full_to_string(datetime)
                return "" unless datetime
                datetime.strftime("%a, %B %d, %Y")
            end
    
            def self.to_string(datetime)
                return "" unless datetime
                datetime.strftime("%Y.%m.%d %H:%M")
            end
    
            def self.date_as_string(datetime)
                return "" unless datetime
                datetime.strftime("%Y.%m.%d")
            end
    
            def self.from_string(string, format="%Y.%m.%d %H:%M")
                return "" unless datetime
                Date.strptime(string, format)
            end

=end

        end

    end

end
