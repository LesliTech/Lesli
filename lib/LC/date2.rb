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

    class Date2

        def initialize(datetime = Time.current, format = "%Y-%m-%d %H:%M:%S")


            # NOTE: user should be able to change this through settings table
            # get initial datetime configuration
            config = Rails.application.config.lesli[:configuration][:datetime]


            # NOTE: Do not modify settings here,
            # if you need a different date format you should change it in the config file
            # Check the docs for more information: /development/docs/rails-lib-time

            # TODO: User should be able to select an appropiate datetime format in an easy way,
            # the Administration module must be present to the users a curated list of different
            # datetime format options with examples, also user should be able to manually modify 
            # the format through an "advanced view"
            @settings = {
                :time_zone => config[:time_zone],
                :start_week_on => config[:start_week_on],
                :format => {
                    :date => "%d.%m.%Y",
                    :time => "%H:%M %p", # 12 hours datetime format
                    :time => "%H:%M",    # 24 hours datetime format (default)
                    :date_time => "%d.%m.%Y %I:%M %p", # 12 hours datetime format
                    :date_time => "%d.%m.%Y %H:%M",    # 24 hours datetime format (default)
                    :date_words => "%A, %B %d, %Y",
                    :date_time_words => "%A, %B %d, %Y, %I:%M %p", # 12 hours datetime in words format
                    :date_time_words => "%A, %B %d, %Y, %H:%M"    # 24 hours datetime in words format (default)
                }
            }


            # default date format
            @format = set_format(:date)


            # get a valid timezone
            @zone = ActiveSupport::TimeZone.new(@settings[:time_zone])


            # get datetime object from user params
            @datetime = parse_initial_datetime(datetime, format).in_time_zone(@zone)

        end

        # set date format and return Date2 instance
        def date
            set_format(:date)
            self
        end

        # set time format and return Date2 instance
        def time
            set_format(:time)
            self
        end

        # set date_time format and return Date2 instance
        def date_time
            set_format(:date_time)
            self
        end

        # set date_words format and return Date2 instance
        def date_words
            set_format(:date_words)
            self
        end

        # set date_time_words format and return Date2 instance
        def date_time_words
            set_format(:date_time_words)
            self
        end

        # return query string to get timestamps columns from database
        def db_timestamps table=""

            # avoid ambiguous columns
            table = table.concat(".") if table != ""

            # get right format for dates
            format = self.db_format

            "TO_CHAR(#{table}created_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '#{format}') as created_at_date, TO_CHAR(#{table}updated_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '#{format}') as updated_at_date"

        end

        # return query string to get a datetime column from database
        def db_column column, table=""

            # avoid ambiguous columns
            table = table.concat(".") if table != ""

            # get right format for dates
            format = self.db_format

            "TO_CHAR(#{table}#{column} at time zone 'utc' at time zone '#{@settings[:time_zone]}', '#{format}') as #{column}_string"

        end

        # convert a datetime object to string representation using defined format
        def to_s
            @datetime.strftime(@format)
        end

        def get
            @datetime
        end

        private


        # get datetime object or string datetime and return a datetime object
        def parse_initial_datetime datetime, format

            return datetime if datetime.is_a?(Time)

            if datetime.is_a?(String) and datetime.size == 25 and datetime[10] == "T"
                return ::DateTime.iso8601(datetime) 
            end 

            return ::DateTime.strptime(datetime, format)
        end


        def set_format format
            @format = @settings[:format][format || :date]
        end


        def db_format
            format = @format

            # Convert Ruby to postgresql date format
            format = format.gsub("%Y", "YYYY")
            format = format.gsub("%m", "MM")
            format = format.gsub("%d", "DD")

            # Convert Ruby to postgresql time format
            format = format.gsub("%H", "HH24") # 24 hours format
            format = format.gsub("%I", "HH12") # 12 hours format
            format = format.gsub("%p", "AM") # Meridian indicator (AM/PM)
            format = format.gsub("%M", "MI")

            format
        end

    end

end
