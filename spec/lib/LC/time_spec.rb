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

[
    "date"
].each do |format|
    RSpec.describe LC::Date, type: :model do
        include_context 'date settings'

        it "LC::Time.db_timestamps" do
            query_string = LC::Time.new.db_timestamps
            query_string = LC::Time.new.format("date").db_timestamps

            query_string = LC::Date.new.db_timestamps
            query_string = LC::Date.new.format("date").db_timestamps
            # TODO
            # expect(query_string.strip).to eq("TO_CHAR(users.created_at at time zone 'utc' at time zone 'America/Guatemala', 'DD/MM/YYYY') as created_at_date, TO_CHAR(users.updated_at at time zone 'utc' at time zone 'America/Guatemala', 'DD/MM/YYYY') as updated_at_date".strip)
        end

    end
end
