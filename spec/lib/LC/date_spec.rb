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
        it "LC::Date.now #{iteration + 1}/#{iterations}" do
            date = LC::Date.now
            settings = LC::Date.reset_settings
            zone = ActiveSupport::TimeZone.new(settings["time_zone"])
            expect(date.format("DD/MM/YYTHH::MM")).to eq(Time.current.in_time_zone(zone).format("DD/MM/YYTHH::MM"))
        end

        it "LC::Date.db_to_char #{iteration + 1}/#{iterations}" do
            query_string = LC::Date.db_to_char(User.first.deleted_at, "deleted_at")
            expect(query_string).to eq("TO_CHAR( at time zone 'utc' at time zone 'America/Guatemala', 'DD/MM/YYYY') as deleted_at")
        end
    end
end
