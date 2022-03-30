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

RSpec.describe 'GET:/administration/roles/options.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        get "/administration/roles/options.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with roles options" do
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("levels")
        expect(@response_body_data["levels"]).to be_an(Array)
        expect(@response_body_data["levels"].first).to be_a(Hash)

        expect(@response_body_data["levels"].first).to have_key("level")
        expect(@response_body_data["levels"].first["level"]).to be_a(Numeric)

        expect(@response_body_data["levels"].first).to have_key("roles")
        expect(@response_body_data["levels"].first["roles"]).to be_an(Array)
    end
end

RSpec.describe 'GET:/administration/roles/options.json', type: :request do
    let(:login){ "/login?r=/administration/roles/options.json" }
    before(:all) do
        get "/administration/roles/options.json"
    end

    it "is expected to redirect to login when user is not authenticated" do
        expect(response).to redirect_to(login)
    end
end