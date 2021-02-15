
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

        def initialize
            config = Rails.application.config.lesli_settings["configuration"]["datetime"]

            # support the old date & time format definition
            date = config["date_format"]
            date_text = config["date_format_full"]
            date_time = config["time_format"]


            # NOTE: Do not modify settings here,
            # if you need a different date format you should change it in the config file
            # Check the docs for more information: /development/docs/rails-lib-time
            @settings = {
                "time_zone" => config["time_zone"], 
                "start_week_on" => config["start_week_on"],
                "format": {
                    "date" => "%d.%m.%Y",
                    "date_text" => "%a, %B %d, %Y",
                    "date_time" => "%d.%m.%Y %H:%M",
                    "time" => "%H:%M"
                }
            }

            # default date format
            @format = "date"

        end

        def date
            format "date"
        end 

        def date_time 
            format "date_time"
        end

        def db_timestamps table=""

            # avoid ambiguous columns
            table = table.concat(".") if table != ""

            # get right format for dates
            format = self.db_format
            
            "TO_CHAR(#{table}created_at at time zone 'utc' at time zone '#{@settings["time_zone"]}', '#{format}') as created_at_date, TO_CHAR(#{table}updated_at at time zone 'utc' at time zone '#{@settings["time_zone"]}', '#{format}') as updated_at_date"

        end


        private 

        def format format
            @format = format
            self
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
