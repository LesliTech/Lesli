=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

# maybe move this to a "LDate" gem?

class Date2

    def initialize(datetime = Time.current, format = "%Y-%m-%d %H:%M:%S")

        # NOTE: user should be able to change this through settings table
        # get initial datetime configuration
        config = Lesli.config.datetime


        # NOTE: Do not modify settings here,
        # if you need a different date format you should change it in the config file
        # Check the docs for more information: /development/docs/rails-lib-time

        # configuration example
        # @settings = {
        #     :time_zone => config[:time_zone],
        #     :start_week_on => config[:start_week_on],
        #     :format => {
        #         :date => "%d.%m.%Y",
        #         :time => "%H:%M %p", # 12 hours datetime format
        #         :time => "%H:%M",    # 24 hours datetime format (default)
        #         :date_time => "%d.%m.%Y %I:%M %p", # 12 hours datetime format
        #         :date_time => "%d.%m.%Y %H:%M",    # 24 hours datetime format (default)
        #         :date_words => "%A, %B %d, %Y",
        #         :date_time_words => "%A, %B %d, %Y, %I:%M %p", # 12 hours datetime in words format
        #         :date_time_words => "%A, %B %d, %Y, %H:%M"    # 24 hours datetime in words format (default)
        #     }
        # }

        @settings = {
            :time_zone => config[:time_zone],
            :start_week_on => config[:start_week_on],
            :format => {
                :date => "%d.%m.%Y",
                :time => "%H:%M",
                :date_time => config[:formats][:date_time],
                :date_words => "%B %d, %Y",             # date in words including day's name
                :date_words_day => "%A, %B %d, %Y",     # date in words including day's name
                :date_time_words => "%B %d, %Y, %H:%M", # 24 hours datetime in words format (default)
                :date_time_words_pm => "%B %d, %Y, %I:%M %p",   # 12 hours datetime in words format
                :date_time_words_day => "%A, %B %d, %Y, %H:%M", # 24 hours datetime in words format (default)
            }
        }


        # default date format
        @format = set_format(:date)


        # get a valid timezone
        @zone = ActiveSupport::TimeZone.new(@settings[:time_zone])


        # get datetime object from user params
        @datetime = parse_initial_datetime(datetime, format).in_time_zone(@zone)

    end

    # Dynamically define formatting methods like `date`, `time`, etc.
    [
        :date, 
        :time, 
        :date_time, 
        :date_words,
        :date_words_day, 
        :date_time_words,
        :date_time_words_pm, 
        :date_time_words_day
    ].each do |key|
        define_method(key) do
            set_format(key)
            self
        end
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

        # compatibility for SQLite
        if ActiveRecord::Base.connection.adapter_name == "SQLite"
            return "strftime('#{format}', #{table}#{column}) as #{column}_string"
        end

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

        if datetime.is_a?(::String) and datetime.size == 25 and datetime[10] == "T"
            return ::DateTime.iso8601(datetime)
        end

        return ::DateTime.strptime(datetime, format)
    end


    def set_format format
        @format = @settings[:format][format || :date]
    end


    def db_format
        format = @format

        # SQLite format dates are the same of ruby format 
        return format if ActiveRecord::Base.connection.adapter_name == "SQLite"

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
