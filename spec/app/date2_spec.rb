
require "rails_helper"
require Lesli::Engine.root.join("lib/rspec/testers/request")

RSpec.describe Date2, type: :model do

    before(:all) do
        @settings = Date2.new.instance_variable_get(:@settings)
    end

    describe "from Time.current object" do 

        it "should parse a new date from Time.current object" do 
            datetime = Date2.new(Time.current).date
            expect(Date2.new(datetime.get).date.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date.to_s).to eql(datetime.to_s)
        end

        it "should parse a new time from Time.current object" do 
            datetime = Date2.new(Time.current).time
            expect(Date2.new(datetime.get).time.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).time.to_s).to eql(datetime.to_s)
        end

        it "should parse a new date_time from Time.current object" do 
            datetime = Date2.new(Time.current).date_time
            expect(Date2.new(datetime.get).date_time.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date_time.to_s).to eql(datetime.to_s)
        end

        it "should parse a new date_words from Time.current object" do 
            datetime = Date2.new(Time.current).date_words
            expect(Date2.new(datetime.get).date_words.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date_words.to_s).to eql(datetime.to_s)
        end

        it "should parse a new date_time_words Time.current object" do 
            datetime = Date2.new(Time.current).date_time_words
            expect(Date2.new(datetime.get).date_time_words.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date_time_words.to_s).to eql(datetime.to_s)
        end

    end

    describe "from iso8601 string" do 

        it "should parse a new date from iso8601 string" do 
            datetime = Date2.new("1990-09-11T05:05:05+00:00").date
            expect(Date2.new(datetime.get).date.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date.to_s).to eql(datetime.to_s)
        end

        it "should parse a new time from iso8601 string" do 
            datetime = Date2.new("1990-09-11T05:05:05+00:00").time
            expect(Date2.new(datetime.get).time.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).time.to_s).to eql(datetime.to_s)
        end

        it "should parse a new date_time from iso8601 string" do 
            datetime = Date2.new("1990-09-11T05:05:05+00:00").date_time
            expect(Date2.new(datetime.get).date_time.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date_time.to_s).to eql(datetime.to_s)
        end

        it "should parse a new date_words from iso8601 string" do 
            datetime = Date2.new("1990-09-11T05:05:05+00:00").date_words
            expect(Date2.new(datetime.get).date_words.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date_words.to_s).to eql(datetime.to_s)
        end

        it "should parse a new date_time_words from iso8601 string" do 
            datetime = Date2.new("1990-09-11T05:05:05+00:00").date_time_words
            expect(Date2.new(datetime.get).date_time_words.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date_time_words.to_s).to eql(datetime.to_s)
        end

    end

    describe "from database datetime column format" do 

        it "should parse a new date from database datetime column format" do 
            datetime = Date2.new("1990-09-11 05:05:00").date
            expect(Date2.new(datetime.get).date.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date.to_s).to eql(datetime.to_s)
        end

        it "should parse a new time from database datetime column format" do 
            datetime = Date2.new("1990-09-11 05:05:00").time
            expect(Date2.new(datetime.get).time.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).time.to_s).to eql(datetime.to_s)
        end

        it "should parse a new date_time from database datetime column format" do 
            datetime = Date2.new("1990-09-11 05:05:00").date_time
            expect(Date2.new(datetime.get).date_time.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date_time.to_s).to eql(datetime.to_s)
        end

        it "should parse a new date_words from database datetime column format" do 
            datetime = Date2.new("1990-09-11 05:05:00").date_words
            expect(Date2.new(datetime.get).date_words.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date_words.to_s).to eql(datetime.to_s)
        end

        it "should parse a new date_time_words from database datetime column format" do 
            datetime = Date2.new("1990-09-11 05:05:00").date_time_words
            expect(Date2.new(datetime.get).date_time_words.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date_time_words.to_s).to eql(datetime.to_s)
        end

    end

    describe "from string with custom format" do 

        it "should parse a new date from string with custom format" do 
            datetime = Date2.new("1990/09/11 05:05", "%Y/%m/%d %H:%M").date
            expect(Date2.new(datetime.get).date.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date.to_s).to eql(datetime.to_s)
        end

        it "should parse a new time from string with custom format" do 
            datetime = Date2.new("1990/09/11 05:05", "%Y/%m/%d %H:%M").time
            expect(Date2.new(datetime.get).time.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).time.to_s).to eql(datetime.to_s)
        end

        it "should parse a new date_time from string with custom format" do 
            datetime = Date2.new("1990/09/11 05:05", "%Y/%m/%d %H:%M").date_time
            expect(Date2.new(datetime.get).date_time.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date_time.to_s).to eql(datetime.to_s)
        end

        it "should parse a new date_words from string with custom format" do 
            datetime = Date2.new("1990/09/11 05:05", "%Y/%m/%d %H:%M").date_words
            expect(Date2.new(datetime.get).date_words.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date_words.to_s).to eql(datetime.to_s)
        end

        it "should parse a new date_time_words from string with custom format" do 
            datetime = Date2.new("1990/09/11 05:05", "%Y/%m/%d %H:%M").date_time_words
            expect(Date2.new(datetime.get).date_time_words.get).to eql(datetime.get)
            expect(Date2.new(datetime.get).date_time_words.to_s).to eql(datetime.to_s)
        end

    end

    describe "for database timestamps" do 

        it "should parse a new date for database timestamps" do 
            datetime = Date2.new.date.db_timestamps
            querystring = "TO_CHAR(created_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', 'DD/MM/YYYY') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', 'DD/MM/YYYY') as updated_at_date"
            querystring = "TO_CHAR(created_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%d/%m/%Y') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%d/%m/%Y') as updated_at_date" if ActiveRecord::Base.connection.adapter_name == "SQLite"
            expect(datetime).to eql(querystring)
        end

        it "should parse a new time for database timestamps" do 
            datetime = Date2.new.time.db_timestamps
            querystring = "TO_CHAR(created_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', 'HH24:MI') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', 'HH24:MI') as updated_at_date"
            querystring = "TO_CHAR(created_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%H:%M') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%H:%M') as updated_at_date" if ActiveRecord::Base.connection.adapter_name == "SQLite"
            expect(datetime).to eql(querystring)
        end

        it "should parse a new date_time for database timestamps" do 
            datetime = Date2.new.date_time.db_timestamps
            querystring = "TO_CHAR(created_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', 'DD/MM/YYYY HH24:MI') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', 'DD/MM/YYYY HH24:MI') as updated_at_date"
            querystring = "TO_CHAR(created_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%d/%m/%Y %H:%M') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%d/%m/%Y %H:%M') as updated_at_date" if ActiveRecord::Base.connection.adapter_name == "SQLite"
            expect(datetime).to eql(querystring)
        end

        it "should parse a new date_words for database timestamps" do 
            datetime = Date2.new.date_words.db_timestamps
            querystring = "TO_CHAR(created_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%B DD, YYYY') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%A, %B DD') as updated_at_date"
            querystring = "TO_CHAR(created_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%B %d, %Y') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%B %d, %Y') as updated_at_date" if ActiveRecord::Base.connection.adapter_name == "SQLite"
            expect(datetime).to eql(querystring)
        end

        it "should parse a new date_time_words for database timestamps" do 
            datetime = Date2.new.date_time_words.db_timestamps
            querystring = "TO_CHAR(created_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%B DD, YYYY, HH24:MI') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%B DD, YYYY, HH24:MI') as updated_at_date"
            querystring = "TO_CHAR(created_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%B %d, %Y, %H:%M') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%B %d, %Y, %H:%M') as updated_at_date" if ActiveRecord::Base.connection.adapter_name == "SQLite"
            expect(datetime).to eql(querystring)
        end

    end

    describe "for database column" do 

        it "should parse a new date for database column" do 
            datetime = Date2.new.date.db_column("deleted_at")
            querystring = "TO_CHAR(deleted_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', 'DD/MM/YYYY') as deleted_at_string"
            querystring = "strftime('%d/%m/%Y', deleted_at) as deleted_at_string" if ActiveRecord::Base.connection.adapter_name == "SQLite"
            expect(datetime).to eql(querystring)
        end

        it "should parse a new time for database column" do 
            datetime = Date2.new.time.db_column("deleted_at")
            querystring = "TO_CHAR(deleted_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', 'HH24:MI') as deleted_at_string"
            querystring = "strftime('%H:%M', deleted_at) as deleted_at_string" if ActiveRecord::Base.connection.adapter_name == "SQLite"
            expect(datetime).to eql(querystring)
        end

        it "should parse a new date_time for database column" do 
            datetime = Date2.new.date_time.db_column("deleted_at")
            querystring = "TO_CHAR(deleted_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', 'DD/MM/YYYY HH24:MI') as deleted_at_string"
            querystring = "strftime('%d/%m/%Y %H:%M', deleted_at) as deleted_at_string" if ActiveRecord::Base.connection.adapter_name == "SQLite"
            expect(datetime).to eql(querystring)
        end

        it "should parse a new date_words for database column" do 
            datetime = Date2.new.date_words.db_column("deleted_at")
            querystring = "TO_CHAR(deleted_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%B DD, YYYY') as deleted_at_string"
            querystring = "strftime('%B %d, %Y', deleted_at) as deleted_at_string" if ActiveRecord::Base.connection.adapter_name == "SQLite"
            expect(datetime).to eql(querystring)
        end

        it "should parse a new date_time_words for database column" do 
            datetime = Date2.new.date_time_words.db_column("deleted_at")
            querystring = "TO_CHAR(deleted_at at time zone 'utc' at time zone '#{@settings[:time_zone]}', '%B DD, YYYY, HH24:MI') as deleted_at_string"
            querystring = "strftime('%B %d, %Y, %H:%M', deleted_at) as deleted_at_string" if ActiveRecord::Base.connection.adapter_name == "SQLite"
            expect(datetime).to eql(querystring)
        end
    end
end
