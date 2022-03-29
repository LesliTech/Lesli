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


RSpec.describe "GET:/administration/role_descriptors/list.json", type: :request do
    include_context 'user authentication'

    before(:all) do
        # Must exist at least one record in the DB
        create(:role_descriptor, account: @user.account)
        get "/administration/role_descriptors/list.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with role descriptors" do
        expect(@response_body_data).to be_an(Array)
        expect(@response_body_data.length).to be >= 1
    end

    it "is expected that role descriptors have all the correct keys and values" do
        expect(@response_body_data.last).to be_a(Hash)
        expect(@response_body_data.last).to have_key("id")
        expect(@response_body_data.last["id"]).to be_a(Numeric)

        expect(@response_body_data.last).to have_key("name")
        expect(@response_body_data.last["name"]).to be_a(String)

        expect(@response_body_data.last).to have_key("description")
        expect(@response_body_data.last["description"]).to be_a(String)

        expect(@response_body_data.last).to have_key("created_at")
        expect(@response_body_data.last["created_at"]).to be_a(String)

        expect(@response_body_data.last).to have_key("role_descriptors_id")
        expect(@response_body_data.last["role_descriptors_id"]).to be_nil
    end

end