
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

module LC

    class Date
 
        # set timezone and date formats here 
 
        # NOTE: Do not modify formats here,
        # if you need a different date format you should change it in the settings
        # Please read the documentation stored in core/docs/leslicommand-date.md for more information
        @settings = {
            "date_format" => "%d.%m.%Y", 
            "date_format_full" => "%a, %B %d, %Y", 
            "date_format_time" => "%d.%m.%Y %H:%M", 
            "time_format" => "%H:%M", 
            "time_zone" => "Europe/Berlin", 
            "start_week_on" => "monday"
        }

        def self.db_timestamps table=""

            # avoid ambiguous columns
            table = table.concat(".") if table != ""

            # get right format for dates
            format = self.db_format
            
            "
            TO_CHAR(#{table}created_at at time zone 'utc' at time zone '#{@settings["time_zone"]}', '#{format}') as created_at_date, 
            TO_CHAR(#{table}updated_at at time zone 'utc' at time zone '#{@settings["time_zone"]}', '#{format}') as updated_at_date
            "
        end

        def self.db_to_char column, alias_name = nil, include_alias = true
            self.verify_settings
            
            alias_name = column unless alias_name
            # get right format for dates
            format = self.db_format
            
            query_string = "TO_CHAR(#{column} at time zone 'utc' at time zone '#{@settings["time_zone"]}', '#{format}')" 
            query_string = "#{query_string} as #{alias_name}" if include_alias
            query_string
        end

        # works similar to db_to_char, but also can receive the format
        def self.db_to_char_custom(column, alias_name: column, include_alias: false, db_format: nil)
            self.verify_settings

            alias_name = column unless alias_name
            db_format = self.db_format unless db_format
            query_string = "TO_CHAR(#{column} at time zone 'utc' at time zone '#{@settings["time_zone"]}', '#{db_format}')" 
            query_string = "#{query_string} as #{alias_name}" if include_alias
            query_string
        end

        # RETURN a Time object with defined timezone
        def self.datetime
            zone = ActiveSupport::TimeZone.new(@settings["time_zone"])
            return Time.current.in_time_zone(zone)
        end
 
        def self.to_string(datetime_object)
            return nil if ! datetime_object
            self.verify_settings
            
            zone = ActiveSupport::TimeZone.new(@settings["time_zone"])
            datetime_object.in_time_zone(zone).strftime(@settings["date_format"])
        end
 
        def self.to_string_datetime(datetime_object)
            return nil if ! datetime_object

            self.verify_settings
            
            zone = ActiveSupport::TimeZone.new(@settings["time_zone"])
            datetime_object.in_time_zone(zone).strftime(@settings["date_format_time"])
        end
 
        def self.to_string_datetime_words(datetime_object)
            return nil if ! datetime_object
            self.verify_settings
            
            zone = ActiveSupport::TimeZone.new(@settings["time_zone"])
            datetime_object.in_time_zone(zone).strftime(@settings["date_format_full"])
        end
 
        def self.to_string_time(datetime_object)
            return nil if ! datetime_object
            self.verify_settings
            
            zone = ActiveSupport::TimeZone.new(@settings["time_zone"])
            datetime_object.in_time_zone(zone).strftime(@settings["time_format"])
        end

        def self.beginning_of_month
            self.verify_settings
            
            zone = ActiveSupport::TimeZone.new(@settings["time_zone"])
            return Time.current.in_time_zone(zone).beginning_of_month
        end
 
        def self.today_at_midnight
            self.verify_settings
            
            zone = ActiveSupport::TimeZone.new(@settings["time_zone"])
            return Time.current.in_time_zone(zone).beginning_of_day
        end
 
        def self.tomorrow_at_midnight
            self.verify_settings
            
            zone = ActiveSupport::TimeZone.new(@settings["time_zone"])
            return Time.current.in_time_zone(zone).beginning_of_day + 1.day
        end 
 
        def self.now
            self.verify_settings
            zone = ActiveSupport::TimeZone.new(@settings["time_zone"])
            return Time.current.in_time_zone(zone)
        end
 


        def self.distance_to_words(time_from, time_to, force_time_zone=false)

            return "never" if time_from.blank?

            self.verify_settings
            
            zone = ActiveSupport::TimeZone.new(@settings["time_zone"])
 
            time_from = time_from.in_time_zone(zone) if force_time_zone
            time_to = time_to.in_time_zone(zone) if force_time_zone

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

            return "right now" if distance_in_seconds === 0
 
            # return generic distance
            return "some time ago"
 
        end
 
        def self.get_year_difference(time_from, time_to)
            self.verify_settings
            
            # We set the same timezone for both Time variables
            zone = ActiveSupport::TimeZone.new(@settings["time_zone"])
            time_from = time_from.in_time_zone(zone)
            time_to = time_to.in_time_zone(zone)
            
            # We extract years, months, and days
            from_year = time_from.year
            to_year = time_to.year
            from_month = time_from.month
            to_month = time_to.month
            from_day = time_from.day
            to_day = time_to.day
 
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


        protected
        
        def self.reset_settings
            @settings = Rails.application.config.lesli_settings["configuration"]["datetime"]
        end
 
        def self.verify_settings
            return if @settings && (!@settings.empty?)
            self.reset_settings
        end

        def self.db_format
            self.verify_settings
            format = @settings["date_format"]
            format = format.gsub("%Y", "YYYY")
            format = format.gsub("%m", "MM")
            format = format.gsub("%d", "DD")
            format
        end
 
    end
 
 end
 