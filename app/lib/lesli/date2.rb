=begin

Lesli

Copyright (c) 2024, Lesli Technologies, S. A.

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

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    class Date2
        def initialize(datetime = Time.current, format = "%Y-%m-%d %H:%M:%S")

            # NOTE: user should be able to change this through settings table
            # get initial datetime configuration

            # IMPORTANT: Do not modify settings here,
            # if you need a different date format you should change it in the config file
            # Check the docs for more information: /development/docs/rails-lib-time
            @settings = Lesli.config.datetime

            # default date format
            @format = set_format(:date)


            # get a valid timezone
            @zone = ActiveSupport::TimeZone.new(@settings[:time_zone])


            # get datetime object from user params
            @datetime = parse_initial_datetime(datetime, format).in_time_zone(@zone)
        end

        # Format setters
        [:date, :time, :date_time, :date_words, :date_time_words].each do |format_type|
            define_method(format_type) do
                set_format(format_type)
                self
            end
        end

        # return query string to get timestamps columns from database
        def db_timestamps(table = "")

            # avoid ambiguous columns
            table_prefix = "#{table}." if !table.empty?

            # get right format for dates
            format = db_format

            <<~SQL.strip
                TO_CHAR(#{table_prefix}created_at AT TIME ZONE 'utc' AT TIME ZONE '#{@settings[:time_zone]}', '#{format}') AS created_at_date,
                TO_CHAR(#{table_prefix}updated_at AT TIME ZONE 'utc' AT TIME ZONE '#{@settings[:time_zone]}', '#{format}') AS updated_at_date
            SQL
        end

        # return query string to get a datetime column from database
        def db_column(column, table = "")

            # avoid ambiguous columns
            table_prefix = "#{table}." if !table.empty?

            # get right format for dates
            format = db_format

            # compatibility for SQLite
            if ActiveRecord::Base.connection.adapter_name == "SQLite"
                "strftime('#{format}', #{table_prefix}#{column}) AS #{column}_string"
            else
                "TO_CHAR(#{table_prefix}#{column} AT TIME ZONE 'utc' AT TIME ZONE '#{@settings[:time_zone]}', '#{format}') AS #{column}_string"
            end
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
        def parse_initial_datetime(datetime, format)
            return datetime if datetime.is_a?(Time)

            if datetime.is_a?(String) && datetime.match?(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/)
                return ::DateTime.iso8601(datetime)
            end

            ::DateTime.strptime(datetime, format)
        rescue ArgumentError
            raise "Invalid datetime format. Please provide a valid datetime."
        end

        def set_format(format_key)
            @format = @settings[:formats][format_key] || @settings[:formats][:date]
        end

        def db_format
            format = @format.dup

            # SQLite format dates are the same of ruby format 
            return format if ActiveRecord::Base.connection.adapter_name == "SQLite"

            # Convert Ruby to postgresql date format
            format.gsub!("%Y", "YYYY")
            format.gsub!("%m", "MM")
            format.gsub!("%d", "DD")
            format.gsub!("%H", "HH24") # 24-hour
            format.gsub!("%I", "HH12") # 12-hour
            format.gsub!("%p", "AM")   # Meridian
            format.gsub!("%M", "MI")   # Minutes

            format
        end
    end
end
