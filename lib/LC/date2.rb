
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

include ActionView::Helpers::DateHelper

module LC

    class Date2

        def initialize(date = Time.current, format_string = "%Y/%m/%d")
            
            config = Rails.application.config.lesli_settings["configuration"]["datetime"]


            # NOTE: Do not modify settings here,
            # if you need a different date format you should change it in the config file
            # Check the docs for more information: /development/docs/rails-lib-time
            @settings = {
                "time_zone" => config["time_zone"], 
                "start_week_on" => config["start_week_on"],
                "format": {
                    "date" => "%d.%m.%Y",
                    "time" => "%H:%M",
                    "date_time" => "%d.%m.%Y %H:%M",
                    "date_words" => "%a, %B %d, %Y",
                    "date_time_words" => "%a, %B %d, %Y, %H:%M",
                }
            }

            # default date format
            @format = "date"

            # get a valid timezone
            @zone = ActiveSupport::TimeZone.new(@settings["time_zone"])

            # work with the default date
            if date.is_a?(String)
                date = ::Date.strptime(date, format_string)
            end

            @date = date

        end

        # Date formats
        def date
            format "date"
            self
        end 

        def time
            format "time"
            self
        end

        def date_time 
            format "date_time"
            self
        end

        def date_words
            format "date_words"
            self
        end

        def date_time_words
            format "date_time_words"
            self
        end


        # Date getters
        def month
            @date.strftime("%m")
        end


        def db_timestamps table=""

            # avoid ambiguous columns
            table = table.concat(".") if table != ""

            # get right format for dates
            format = self.db_format
            
            "TO_CHAR(#{table}created_at at time zone 'utc' at time zone '#{@settings["time_zone"]}', '#{format}') as created_at_date, TO_CHAR(#{table}updated_at at time zone 'utc' at time zone '#{@settings["time_zone"]}', '#{format}') as updated_at_date"

        end

        def db_column column
            format = self.db_format
            "TO_CHAR(#{column} at time zone 'utc' at time zone '#{@settings["time_zone"]}', '#{format}') as #{column}_date" 
        end

        def now
            Time.current.in_time_zone(@zone)
        end

        def to_s
            format = @settings[:format][@format || "date"]
            @date.in_time_zone(@zone).strftime(format)
        end


        private 

        
        def format format
            @format = format
        end

        def db_format
            format = @settings[:format][@format || "date"]

            # Convert Ruby to postgresql date format
            format = format.gsub("%Y", "YYYY")
            format = format.gsub("%m", "MM")
            format = format.gsub("%d", "DD")

            # Convert Ruby to postgresql time format
            format = format.gsub("%H", "HH24")
            format = format.gsub("%M", "MI")

            #format.concat("AM")

            format
        end

    end

end
