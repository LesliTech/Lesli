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

LC::Date2.new.date
LC::Date2.new.time
LC::Date2.new.date_time
LC::Date2.new.date_words

LC::Date2.new.date                                      => Tue, 23 Feb 2021 18:20:32.140146000 CST -06:00 (current time)
LC::Date2.new(Time.current).date                        => Tue, 23 Feb 2021 18:20:32.140146000 CST -06:00
LC::Date2.new(string in ISO 8601).date                  => Tue, 23 Feb 2021 18:20:32.140146000 CST -06:00
LC::Date2.new("2021/02/23", "YYYY/MM/DD").date.to_s     => "2021/02/23"

LC::Date2.new.date.db_timestamps
LC::Date2.new.time.db_timestamps
LC::Date2.new.date_time.db_timestamps

=end

RSpec.describe LC::Date2, type: :model do

    before(:all) do
        @settings = LC::Date2.new.instance_variable_get(:@settings)
    end

    it "is expect to render db_timestamps columns" do
        expect(LC::Date2.new.db_timestamps).to eql("TO_CHAR(created_at at time zone 'utc' at time zone '#{@settings["time_zone"]}', 'DD.MM.YYYY') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone '#{@settings["time_zone"]}', 'DD.MM.YYYY') as updated_at_date")
    end

    it "is expect to render db_timestamps columns with format date" do
        expect(LC::Date2.new.date.db_timestamps).to eql("TO_CHAR(created_at at time zone 'utc' at time zone '#{@settings["time_zone"]}', 'DD.MM.YYYY') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone '#{@settings["time_zone"]}', 'DD.MM.YYYY') as updated_at_date")
    end

    it "is expect to render db_timestamps columns with format date_time" do
        expect(LC::Date2.new.date_time.db_timestamps).to eql("TO_CHAR(created_at at time zone 'utc' at time zone '#{@settings["time_zone"]}', 'DD.MM.YYYY HH24:MI') as created_at_date, TO_CHAR(updated_at at time zone 'utc' at time zone '#{@settings["time_zone"]}', 'DD.MM.YYYY HH24:MI') as updated_at_date")
    end
=begin
    it "is expect to render current_time as string" do
        LC::Debug.msg LC::Date2.new.date.to_s
        expect(LC::Date2.new.date.to_s).to eql("date")
    end
=end
end
