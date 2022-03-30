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


RSpec.describe "GET:/administration/roles/:id/descriptor_assignments/options.json", type: :request do
    include_context "user authentication"

    let!(:categories) { ["index", "create", "update","show","destroy", "search"] }

    before(:all) do
        get "/administration/roles/descriptor_assignments/options.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with role descriptor assignments options" do
        expect(@response_body_data).to be_a(Hash)
        
        expect(@response_body_data).to have_key("descriptors")
        expect(@response_body_data["descriptors"]).to be_an(Array)

        expect(@response_body_data).to have_key("categories")
        expect(@response_body_data["categories"]).to be_an(Array)
        expect(@response_body_data["categories"]).to match_array categories
    end
end

RSpec.describe "GET:/administration/roles/:id/descriptor_assignments/options.json", type: :request do
    let!(:login) { "/login?r=/administration/roles/descriptor_assignments/options.json" }
    before(:all) do
        get "/administration/roles/descriptor_assignments/options.json"
    end

    it "is expected to redirect to login when user is not authenticated" do
        expect(response).to redirect_to(login)
    end
end