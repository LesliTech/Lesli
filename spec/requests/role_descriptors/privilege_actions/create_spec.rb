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

require 'rails_helper'
require 'spec_helper'
require 'byebug'


RSpec.describe "POST:/administration/role_descriptors/:id/privilege_actions.json", type: :request do

    include_context "user authentication"

    before(:all) do
        @role_descriptor = create(:role_descriptor, account: @user.account)
        @privilege_action = attributes_for(:privilege_action, role_descriptors_id: @role_descriptor.id)

        post("/administration/role_descriptors/#{@role_descriptor.id}/privilege_actions.json", params: {
            role_descriptor_privilege_action: @privilege_action
        })
    end

    include_examples "successful standard json response"

    it "is expected to respond with a privilege action created successfully" do
        expect(@response_body_data).to be_a(Hash)
        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be > 0
    end

    it "is expected to respond with all correct keys and data types" do
        expect(@response_body_data).to have_key("category")
        expect(@response_body_data["category"]).to be_a(String)
        expect(@response_body_data["category"]).to eql(@privilege_action[:category])

        expect(@response_body_data).to have_key("status")
        expect(@response_body_data["status"]).to be_truthy

        expect(@response_body_data).to have_key("deleted_at")
        expect(@response_body_data["deleted_at"]).to be_nil

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at")
        expect(@response_body_data["updated_at"]).to be_a(String)

        expect(@response_body_data).to have_key("role_descriptors_id")
        expect(@response_body_data["role_descriptors_id"]).to be_a(Numeric)
        expect(@response_body_data["role_descriptors_id"]).to eql(@privilege_action[:role_descriptors_id])

        expect(@response_body_data).to have_key("system_controller_actions_id")
        expect(@response_body_data["system_controller_actions_id"]).to be_a(Numeric)
        expect(@response_body_data["system_controller_actions_id"]).to eql(@privilege_action[:system_controller_actions_id])
    end

end


RSpec.describe "POST:/administration/role_descriptors/:id/privilege_actions.json", type: :request do

    include_context "user authentication"

    before(:all) do
        @role_descriptor = create(:role_descriptor, account: @user.account)
        @privilege_action = attributes_for(:invalid_privilege_action, role_descriptors_id: @role_descriptor.id)

        post("/administration/role_descriptors/#{@role_descriptor.id}/privilege_actions.json", params: {
            role_descriptor_privilege_action: @privilege_action
        })
    end

    include_examples "error standard json response"

    it "is expected to respond with error when all required params are nil" do
        expect(@response_body["error"]).to be_a(Hash)
        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_an(Array)
    end
end

RSpec.describe "POST:/administration/role_descriptors/:id/privilege_actions.json", type: :request do
    let!(:account){ create(:account) }
    let!(:role_descriptor_id){ create(:role_descriptor, account: account).id  }
    let(:login) { "/login" }

    before do
        post("/administration/role_descriptors/#{role_descriptor_id}/privilege_actions.json", params: {
            role_descriptor_privilege_action: {}
        })
    end

    it "is expected to respond with error when all required params are nil" do
        expect(response).to redirect_to(login)
    end
end