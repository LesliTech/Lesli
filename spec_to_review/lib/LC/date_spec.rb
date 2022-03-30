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


def db_format
    format = @settings["date_format"]

    # Convert Ruby to postgresql date format
    format = format.gsub("%Y", "YYYY")
    format = format.gsub("%m", "MM")
    format = format.gsub("%d", "DD")

    format
end

RSpec.describe LC::Date, type: :model do

    before(:all) do
        @settings = LC::Date.reset_settings
        @zone = ActiveSupport::TimeZone.new(@settings["time_zone"])
    end

    it "LC::Date.now" do
        date = LC::Date.now
        expect(date.format("DD/MM/YYTHH::MM")).to eq(Time.current.in_time_zone(@zone).format("DD/MM/YYTHH::MM"))
    end

    it "LC::Date.db_timestamps" do
        query_string = LC::Date.db_timestamps("users")
        # TODO
        # expect(query_string.strip).to eq("TO_CHAR(users.created_at at time zone 'utc' at time zone 'America/Guatemala', 'DD/MM/YYYY') as created_at_date, TO_CHAR(users.updated_at at time zone 'utc' at time zone 'America/Guatemala', 'DD/MM/YYYY') as updated_at_date".strip)
    end

    it "LC::Date.db_to_timezone" do
        query_string = LC::Date.db_to_timezone(User.first.deleted_at, "deleted_at")
        expect(query_string).to eq("( at time zone 'utc' at time zone '#{@settings["time_zone"]}') as deleted_at")
    end

    it "LC::Date.db_to_char" do
        query_string = LC::Date.db_to_char(User.first.deleted_at, "deleted_at")
        expect(query_string).to eq("TO_CHAR( at time zone 'utc' at time zone '#{@settings["time_zone"]}', '#{self.db_format}') as deleted_at")
    end

    it "LC::Date.db_to_char_custom" do
        query_string = LC::Date.db_to_char_custom(User.first.deleted_at)
        expect(query_string).to eq("TO_CHAR( at time zone 'utc' at time zone '#{@settings["time_zone"]}', '#{self.db_format}')")
    end

    it "LC::Date.datetime" do
        datetime = LC::Date.datetime
        expect(datetime.format("DD/MM/YYTHH::MM")).to eq(Time.current.in_time_zone(@zone).format("DD/MM/YYTHH::MM"))
    end

    it "LC::Date.to_string" do
        date = LC::Date.now
        date_string = LC::Date.to_string(date)
        expect(date_string).to eq(date.in_time_zone(@zone).strftime(@settings["date_format"]))
    end

    it "LC::Date.to_string_datetime" do
        date = LC::Date.now
        date_string = LC::Date.to_string_datetime(date)
        expect(date_string).to eq(date.in_time_zone(@zone).strftime(@settings["date_format_time"]))
    end

    it "LC::Date.to_string_datetime_words" do
        date = LC::Date.now
        date_string = LC::Date.to_string_datetime_words(date)
        expect(date_string).to eq(I18n.l(date.in_time_zone(@zone), format: @settings["date_format_full"]))
    end

    it "LC::Date.to_string_time" do
        date = LC::Date.now
        date_string = LC::Date.to_string_time(date)
        expect(date_string).to eq(date.in_time_zone(@zone).strftime(@settings["time_format"]))
    end

    it "LC::Date.beginning_of_month" do
        first_day_month = LC::Date.beginning_of_month
        expect(first_day_month).to eq(Time.current.in_time_zone(@zone).beginning_of_month)
    end

    it "LC::Date.today_at_midnight" do
        today_midnight = LC::Date.today_at_midnight
        expect(today_midnight).to eq(Time.current.in_time_zone(@zone).beginning_of_day)
    end

    it "LC::Date.tomorrow_at_midnight" do
        tomorrow_midnight = LC::Date.tomorrow_at_midnight
        expect(tomorrow_midnight).to eq(Time.current.in_time_zone(@zone).beginning_of_day + 1.day)
    end

    it "LC::Date.distance_to_words" do
        date_from = LC::Date.datetime("17/12/1998")
        date_to = LC::Date.tomorrow_at_midnight
        distance_to_words = LC::Date.distance_to_words(date_from, date_to)
        expect(distance_to_words).to eq(distance_of_time_in_words(date_from, date_to, include_seconds: true))
    end

    it "LC::Date.distance_to_words" do
        date_from = LC::Date.datetime("17/12/1998")
        date_to = LC::Date.datetime("17/12/2021")
        distance_to_words = LC::Date.distance_to_words(date_from, date_to)
        expect(distance_to_words).to eq("about 23 years")
    end

    it "LC::Date.get_year_difference" do
        date_from = LC::Date.datetime("17/12/1998")
        date_to = LC::Date.datetime("17/12/2021")
        year_difference = LC::Date.get_year_difference(date_from, date_to)
        expect(year_difference).to eq(23)
    end
end
