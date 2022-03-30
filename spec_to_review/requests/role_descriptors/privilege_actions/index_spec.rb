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

RSpec.describe "GET:/administration/role_descriptors/:id/privilege_actions.json", type: :request do

    include_context "user authentication"

    before(:all) do
        @role_descriptor = create(:role_descriptor, account: @user.account) 
        @privilege_action = create_list(:privilege_action, 10, role_descriptors_id: @role_descriptor.id)

        get "/administration/role_descriptors/#{@role_descriptor.id}/privilege_actions.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with privilege actions of role descriptors" do
        expect(@response_body_data).to be_an(Array)
        expect(@response_body_data.first).to be_a(Hash)
        expect(@response_body_data.first).to have_key("id")
        expect(@response_body_data.first["id"]).to be_a(Numeric)
        expect(@response_body_data.first["id"]).to be >= @privilege_action.length
    end

    it "is expected that the privilege actions have all correct keys and data types" do
        expect(@response_body_data.first).to have_key("status")
        expect(@response_body_data.first["status"]).to be_truthy

        expect(@response_body_data.first).to have_key("category")
        expect(@response_body_data.first["category"]).to be_a(String)

        expect(@response_body_data.first).to have_key("controller")
        expect(@response_body_data.first["controller"]).to be_a(String)

        expect(@response_body_data.first).to have_key("controller_id")
        expect(@response_body_data.first["controller_id"]).to be_a(Numeric)

        expect(@response_body_data.first).to have_key("action")
        expect(@response_body_data.first["action"]).to be_a(String)

        expect(@response_body_data.first).to have_key("action_id")
        expect(@response_body_data.first["action_id"]).to be_a(Numeric)
    end
end


RSpec.describe "GET:/administration/role_descriptors/:id/privilege_actions.json", type: :request do
    let!(:account){ create(:account) }
    let!(:role_descriptor_id){ create(:role_descriptor, account: account).id  }
    let(:login) { "/login" }

    before do
        post("/administration/role_descriptors/#{role_descriptor_id}/privilege_actions.json", params: {
            role_descriptor_privilege_action: {}
        })
    end

    it "is expected to respond with error when the user is not authenticated" do
        expect(response).to redirect_to(login)
    end
end