=begin
Copyright (c) 2021, all rights reserved.

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

RSpec.describe "GET:/administration/account/settings/options", type: :request do 

    include_context "user authentication"

    before(:all) do 
        get "/administration/account/settings/options.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with an array with all options information" do 

        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("time_zones")
        expect(@response_body_data).to have_key("days_into_week")

        expect(@response_body_data["time_zones"]).to be_an(Array)
        expect(@response_body_data["days_into_week"]).to be_an(Array)

        # time_zones
        expect(@response_body_data["time_zones"].length).not_to be(0)
        expect(@response_body_data["time_zones"].length).to be > 0

        expect(@response_body_data["time_zones"].at(0)).to be_a(Hash)

        expect(@response_body_data["time_zones"].at(0)).to have_key("value")
        expect(@response_body_data["time_zones"].at(0)["value"]).to be_a(String)

        expect(@response_body_data["time_zones"].at(0)).to have_key("text")
        expect(@response_body_data["time_zones"].at(0)["text"]).to be_a(String)

        # days_into_week
        expect(@response_body_data["days_into_week"].length).to eq(7)
        expect(@response_body_data["days_into_week"].at(0)).to be_a(Hash)

        expect(@response_body_data["days_into_week"].at(0)).to have_key("value")
        expect(@response_body_data["days_into_week"].at(0)["value"]).to be_a(String)
        
        expect(@response_body_data["days_into_week"].at(0)).to have_key("text")
        expect(@response_body_data["days_into_week"].at(0)["text"]).to be_a(String)

    end


end