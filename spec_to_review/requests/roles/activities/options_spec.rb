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

RSpec.describe "GET:/administration/roles/activities/options.json", type: :request do
    include_context "user authentication"

    let(:categories) do
        {
            action_create:                          "action_create",
            action_show:                            "action_show",
            action_update:                          "action_update",
            action_destroy:                         "action_destroy",
            action_update_role_privilege:           "action_update_role_privilege",
            action_create_role_privilege:           "action_create_role_privilege",
            action_create_descriptor_assignment:    "action_create_descriptor_assignment",
            action_destroy_descriptor_assignment:   "action_destroy_descriptor_assignment"
        }
    end

    before(:all) do
        get "/administration/roles/activities/options.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with the categories of activities" do
        expect(@response_body_data).to be_a(Hash)
        expect(@response_body_data).to have_key("categories")
        expect(@response_body_data["categories"]).to be_an(Array)
        expect(@response_body_data["categories"].length).to be >= (categories.keys.length)

        expect(@response_body_data["categories"].first).to be_a(Hash)
        expect(@response_body_data["categories"].first).to have_key("value")
        expect(@response_body_data["categories"].first["value"]).to eql(categories.values.first)
        expect(@response_body_data["categories"].first).to have_key("text")
        expect(@response_body_data["categories"].first["text"]).to eql(categories.values.first)
    end
end

RSpec.describe "GET:/administration/roles/activities/options.json", type: :request do
    let(:login) { "/login?r=/administration/roles/activities/options.json" }
    before(:all) do
        get "/administration/roles/activities/options.json"
    end

    it "is expected to redirect to login when user is not authenticated" do
        expect(response).to redirect_to(login)
    end
end