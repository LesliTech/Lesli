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


=begin

# TODO:

# Date getters 
LC::Date2.new.date.month
LC::Date2.new.date.start_of_day
LC::Date2.new.date.start_of_week
LC::Date2.new.date.start_of_month
LC::Date2.new.date.end_of_day
LC::Date2.new.date.end_of_week
LC::Date2.new.date.end_of_month

# Date query**
LC::Date2.new.date.from(Date.new)
LC::Date2.new.date.to(Date.new)

# Date helpers for database
LC::Date2.new.date.db_timestamps
LC::Date2.new.date.db_column

=end

RSpec.describe "LC::Date2.new", type: :model do

    before(:all) do
        @settings = LC::Date2.new.instance_variable_get(:@settings)
    end

    # -- from Time.current object

    it "should parse a new date from Time.current object" do 
        datetime = LC::Date2.new(Time.current).date
        expect(LC::Date2.new(datetime.get).date.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date.to_s).to eql(datetime.to_s)
    end

    it "should parse a new time from Time.current object" do 
        datetime = LC::Date2.new(Time.current).time
        expect(LC::Date2.new(datetime.get).time.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).time.to_s).to eql(datetime.to_s)
    end

    it "should parse a new date_time from Time.current object" do 
        datetime = LC::Date2.new(Time.current).date_time
        expect(LC::Date2.new(datetime.get).date_time.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date_time.to_s).to eql(datetime.to_s)
    end

    it "should parse a new date_words from Time.current object" do 
        datetime = LC::Date2.new(Time.current).date_words
        expect(LC::Date2.new(datetime.get).date_words.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date_words.to_s).to eql(datetime.to_s)
    end

    it "should parse a new date_time_words Time.current object" do 
        datetime = LC::Date2.new(Time.current).date_time_words
        expect(LC::Date2.new(datetime.get).date_time_words.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date_time_words.to_s).to eql(datetime.to_s)
    end

    # -- from iso8601 string

    it "should parse a new date from iso8601 string" do 
        datetime = LC::Date2.new("1990-09-11T05:05:05+00:00").date
        expect(LC::Date2.new(datetime.get).date.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date.to_s).to eql(datetime.to_s)
    end

    it "should parse a new time from iso8601 string" do 
        datetime = LC::Date2.new("1990-09-11T05:05:05+00:00").time
        expect(LC::Date2.new(datetime.get).time.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).time.to_s).to eql(datetime.to_s)
    end

    it "should parse a new date_time from iso8601 string" do 
        datetime = LC::Date2.new("1990-09-11T05:05:05+00:00").date_time
        expect(LC::Date2.new(datetime.get).date_time.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date_time.to_s).to eql(datetime.to_s)
    end

    it "should parse a new date_words from iso8601 string" do 
        datetime = LC::Date2.new("1990-09-11T05:05:05+00:00").date_words
        expect(LC::Date2.new(datetime.get).date_words.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date_words.to_s).to eql(datetime.to_s)
    end

    it "should parse a new date_time_words from iso8601 string" do 
        datetime = LC::Date2.new("1990-09-11T05:05:05+00:00").date_time_words
        expect(LC::Date2.new(datetime.get).date_time_words.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date_time_words.to_s).to eql(datetime.to_s)
    end

    # -- from database datetime column format

    it "should parse a new date from database datetime column format" do 
        datetime = LC::Date2.new("1990-09-11 05:05:00").date
        expect(LC::Date2.new(datetime.get).date.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date.to_s).to eql(datetime.to_s)
    end

    it "should parse a new time from database datetime column format" do 
        datetime = LC::Date2.new("1990-09-11 05:05:00").time
        expect(LC::Date2.new(datetime.get).time.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).time.to_s).to eql(datetime.to_s)
    end

    it "should parse a new date_time from database datetime column format" do 
        datetime = LC::Date2.new("1990-09-11 05:05:00").date_time
        expect(LC::Date2.new(datetime.get).date_time.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date_time.to_s).to eql(datetime.to_s)
    end

    it "should parse a new date_words from database datetime column format" do 
        datetime = LC::Date2.new("1990-09-11 05:05:00").date_words
        expect(LC::Date2.new(datetime.get).date_words.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date_words.to_s).to eql(datetime.to_s)
    end

    it "should parse a new date_time_words from database datetime column format" do 
        datetime = LC::Date2.new("1990-09-11 05:05:00").date_time_words
        expect(LC::Date2.new(datetime.get).date_time_words.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date_time_words.to_s).to eql(datetime.to_s)
    end

    # -- from string with custom format

    it "should parse a new date from string with custom format" do 
        datetime = LC::Date2.new("1990/09/11 05:05", "%Y/%m/%d %H:%M").date
        expect(LC::Date2.new(datetime.get).date.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date.to_s).to eql(datetime.to_s)
    end

    it "should parse a new time from string with custom format" do 
        datetime = LC::Date2.new("1990/09/11 05:05", "%Y/%m/%d %H:%M").time
        expect(LC::Date2.new(datetime.get).time.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).time.to_s).to eql(datetime.to_s)
    end

    it "should parse a new date_time from string with custom format" do 
        datetime = LC::Date2.new("1990/09/11 05:05", "%Y/%m/%d %H:%M").date_time
        expect(LC::Date2.new(datetime.get).date_time.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date_time.to_s).to eql(datetime.to_s)
    end

    it "should parse a new date_words from string with custom format" do 
        datetime = LC::Date2.new("1990/09/11 05:05", "%Y/%m/%d %H:%M").date_words
        expect(LC::Date2.new(datetime.get).date_words.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date_words.to_s).to eql(datetime.to_s)
    end

    it "should parse a new date_time_words from string with custom format" do 
        datetime = LC::Date2.new("1990/09/11 05:05", "%Y/%m/%d %H:%M").date_time_words
        expect(LC::Date2.new(datetime.get).date_time_words.get).to eql(datetime.get)
        expect(LC::Date2.new(datetime.get).date_time_words.to_s).to eql(datetime.to_s)
    end

    # -- for database timestamps

    it "should parse a new date for database timestamps" do 
        datetime = LC::Date2.new.date.db_timestamps
        querystring = "TO_CHAR(created_at at time zone 'utc' at time zone 'America/Guatemala', 'DD.MM.YYYY') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone 'America/Guatemala', 'DD.MM.YYYY') as updated_at_date"
        expect(datetime).to eql(querystring)
    end

    it "should parse a new time for database timestamps" do 
        datetime = LC::Date2.new.time.db_timestamps
        querystring = "TO_CHAR(created_at at time zone 'utc' at time zone 'America/Guatemala', 'HH24:MI') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone 'America/Guatemala', 'HH24:MI') as updated_at_date"
        expect(datetime).to eql(querystring)
    end

    it "should parse a new date_time for database timestamps" do 
        datetime = LC::Date2.new.date_time.db_timestamps
        querystring = "TO_CHAR(created_at at time zone 'utc' at time zone 'America/Guatemala', 'DD.MM.YYYY HH24:MI') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone 'America/Guatemala', 'DD.MM.YYYY HH24:MI') as updated_at_date"
        expect(datetime).to eql(querystring)
    end

    it "should parse a new date_words for database timestamps" do 
        datetime = LC::Date2.new.date_words.db_timestamps
        querystring = "TO_CHAR(created_at at time zone 'utc' at time zone 'America/Guatemala', '%a, %B DD, YYYY') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone 'America/Guatemala', '%a, %B DD, YYYY') as updated_at_date"
        expect(datetime).to eql(querystring)
    end

    it "should parse a new date_time_words for database timestamps" do 
        datetime = LC::Date2.new.date_time_words.db_timestamps
        querystring = "TO_CHAR(created_at at time zone 'utc' at time zone 'America/Guatemala', '%a, %B DD, YYYY, HH24:MI') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone 'America/Guatemala', '%a, %B DD, YYYY, HH24:MI') as updated_at_date"
        expect(datetime).to eql(querystring)
    end

    # -- for database column

    it "should parse a new date for database column" do 
        datetime = LC::Date2.new.date.db_column("deleted_at")
        querystring = "TO_CHAR(deleted_at at time zone 'utc' at time zone 'America/Guatemala', 'DD.MM.YYYY') as deleted_at_date"
        expect(datetime).to eql(querystring)
    end

    it "should parse a new time for database column" do 
        datetime = LC::Date2.new.time.db_column("deleted_at")
        querystring = "TO_CHAR(deleted_at at time zone 'utc' at time zone 'America/Guatemala', 'HH24:MI') as deleted_at_date"
        expect(datetime).to eql(querystring)
    end

    it "should parse a new date_time for database column" do 
        datetime = LC::Date2.new.date_time.db_column("deleted_at")
        querystring = "TO_CHAR(deleted_at at time zone 'utc' at time zone 'America/Guatemala', 'DD.MM.YYYY HH24:MI') as deleted_at_date"
        expect(datetime).to eql(querystring)
    end

    it "should parse a new date_words for database column" do 
        datetime = LC::Date2.new.date_words.db_column("deleted_at")
        querystring = "TO_CHAR(deleted_at at time zone 'utc' at time zone 'America/Guatemala', '%a, %B DD, YYYY') as deleted_at_date"
        expect(datetime).to eql(querystring)
    end

    it "should parse a new date_time_words for database column" do 
        datetime = LC::Date2.new.date_time_words.db_column("deleted_at")
        querystring = "TO_CHAR(deleted_at at time zone 'utc' at time zone 'America/Guatemala', '%a, %B DD, YYYY, HH24:MI') as deleted_at_date"
        expect(datetime).to eql(querystring)
    end

end
