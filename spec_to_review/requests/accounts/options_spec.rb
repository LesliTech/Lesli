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

require 'rails_helper'
require 'spec_helper'
require 'byebug'

RSpec.describe "GET:/administration/account.json", type: :request do

    include_context 'user authentication'

    before(:all) do 
        @regions = Account.regions
        @countries = Account::Location.list(@user, {:filters => { :type => "country" }})
        get "/administration/account/options.json"
    end

    include_examples 'successful standard json response'

    it "is expected to respond with account options" do 
        expect(@response_body_data).to be_a(Hash)
        expect(@response_body_data.keys).to contain_exactly("regions", "countries")

        expect(@response_body_data["regions"]).to be_an(Array)
        expect(@response_body_data["regions"].length).to eql(@regions.length)
        expect(@response_body_data["regions"].last).to be_a(Hash)
        expect(@response_body_data["regions"].last.keys).to contain_exactly("key", "value")

        expect(@response_body_data["regions"].last["key"]).to be_a(String)
        expect(@response_body_data["regions"].last["value"]).to be_a(String)

        expect(@response_body_data["countries"]).to be_an(Array)
        expect(@response_body_data["countries"].length).to eql(@countries.length)
    end

end