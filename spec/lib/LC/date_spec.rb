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

require "rails_helper"
require "spec_helper"
require "byebug"

iterations = 2
iterations.times do |iteration|
    RSpec.describe LC::Date, type: :model do
        include_context 'date settings'

        it "LC::Date.now #{iteration + 1}/#{iterations}" do
            date = LC::Date.now
            expect(date.format("DD/MM/YYTHH::MM")).to eq(Time.current.in_time_zone(@zone).format("DD/MM/YYTHH::MM"))
        end

        it "LC::Date.db_timestamps #{iteration + 1}/#{iterations}" do
            query_string = LC::Date.db_timestamps("users")
            # TODO
            # expect(query_string.strip).to eq("TO_CHAR(users.created_at at time zone 'utc' at time zone 'America/Guatemala', 'DD/MM/YYYY') as created_at_date, TO_CHAR(users.updated_at at time zone 'utc' at time zone 'America/Guatemala', 'DD/MM/YYYY') as updated_at_date".strip)
        end

        it "LC::Date.db_to_timezone #{iteration + 1}/#{iterations}" do
            query_string = LC::Date.db_to_timezone(User.first.deleted_at, "deleted_at")
            expect(query_string).to eq("( at time zone 'utc' at time zone 'America/Guatemala') as deleted_at")
        end

        it "LC::Date.db_to_char #{iteration + 1}/#{iterations}" do
            query_string = LC::Date.db_to_char(User.first.deleted_at, "deleted_at")
            expect(query_string).to eq("TO_CHAR( at time zone 'utc' at time zone 'America/Guatemala', 'DD/MM/YYYY') as deleted_at")
        end

        it "LC::Date.db_to_char_custom #{iteration + 1}/#{iterations}" do
            query_string = LC::Date.db_to_char_custom(User.first.deleted_at)
            expect(query_string).to eq("TO_CHAR( at time zone 'utc' at time zone 'America/Guatemala', 'DD/MM/YYYY')")
        end

        it "LC::Date.datetime #{iteration + 1}/#{iterations}" do
            datetime = LC::Date.datetime
            expect(datetime.format("DD/MM/YYTHH::MM")).to eq(Time.current.in_time_zone(@zone).format("DD/MM/YYTHH::MM"))
        end

        it "LC::Date.to_string #{iteration + 1}/#{iterations}" do
            date = LC::Date.now
            date_string = LC::Date.to_string(date)
            expect(date_string).to eq(date.in_time_zone(@zone).strftime(@settings["date_format"]))
        end

        it "LC::Date.to_string_datetime #{iteration + 1}/#{iterations}" do
            date = LC::Date.now
            date_string = LC::Date.to_string_datetime(date)
            expect(date_string).to eq(date.in_time_zone(@zone).strftime(@settings["date_format_time"]))
        end

        it "LC::Date.to_string_datetime_words #{iteration + 1}/#{iterations}" do
            date = LC::Date.now
            date_string = LC::Date.to_string_datetime_words(date)
            expect(date_string).to eq(I18n.l(date.in_time_zone(@zone), format: @settings["date_format_full"]))
        end

        it "LC::Date.to_string_time #{iteration + 1}/#{iterations}" do
            date = LC::Date.now
            date_string = LC::Date.to_string_time(date)
            expect(date_string).to eq(date.in_time_zone(@zone).strftime(@settings["time_format"]))
        end

        it "LC::Date.beginning_of_month #{iteration + 1}/#{iterations}" do
            first_day_month = LC::Date.beginning_of_month
            expect(first_day_month).to eq(Time.current.in_time_zone(@zone).beginning_of_month)
        end

        it "LC::Date.today_at_midnight #{iteration + 1}/#{iterations}" do
            today_midnight = LC::Date.today_at_midnight
            expect(today_midnight).to eq(Time.current.in_time_zone(@zone).beginning_of_day)
        end

        it "LC::Date.tomorrow_at_midnight #{iteration + 1}/#{iterations}" do
            tomorrow_midnight = LC::Date.tomorrow_at_midnight
            expect(tomorrow_midnight).to eq(Time.current.in_time_zone(@zone).beginning_of_day + 1.day)
        end

        it "LC::Date.distance_to_words #{iteration + 1}/#{iterations}" do
            date_from = LC::Date.datetime("17/12/1998")
            date_to = LC::Date.tomorrow_at_midnight
            distance_to_words = LC::Date.distance_to_words(date_from, date_to)
            expect(distance_to_words).to eq(distance_of_time_in_words(date_from, date_to, include_seconds: true))
        end

        it "LC::Date.get_year_difference #{iteration + 1}/#{iterations}" do
            date_from = LC::Date.datetime("17/01/1998")
            date_to = LC::Date.tomorrow_at_midnight
            year_difference = LC::Date.get_year_difference(date_from, date_to)

            time_from = date_from.in_time_zone(@zone)
            time_to = date_to.in_time_zone(@zone)

            from_year = time_from.year
            to_year = time_to.year
            from_month = time_from.month
            to_month = time_to.month
            from_day = time_from.day
            to_day = time_to.day

            year_difference2 = to_year - from_year
            year_difference2 - 1 if from_month > to_month
            year_difference2 - 1 if (from_day > to_day) && (from_month == to_month)

            expect(year_difference).to eq(year_difference2)
        end
    end
end
