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

RSpec.describe "PUT:/administration/role_descriptors/:id/privilege_actions/:id.json", type: :request do

    include_context "user authentication"

    before(:all) do   
        @role_descriptor = create(:role_descriptor, account: @user.account) 
        @privilege_action = create(:privilege_action, role_descriptors_id: @role_descriptor.id)
        @new_data = attributes_for(:privilege_action, role_descriptors_id: @role_descriptor.id)

        put("/administration/role_descriptors/#{@role_descriptor.id}/privilege_actions/#{@privilege_action.id}.json", params: {
            role_descriptor_privilege_action: @new_data
        })
    end

    include_examples "successful standard json response"

    it "is expected to respond with a privilege action updated" do
        expect(@response_body_data).to be_a(Hash)
        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)

        expect(@response_body_data).to have_key("role_descriptors_id")
        expect(@response_body_data["role_descriptors_id"]).to be_a(Numeric)

        expect(@response_body_data).to have_key("category")
        expect(@response_body_data["category"]).to be_a(String)
        expect(@response_body_data["category"]).to eql(@new_data[:category])

        expect(@response_body_data).to have_key("status")
        expect(@response_body_data["status"]).to be_truthy
        expect(@response_body_data["status"]).to eql(@new_data[:status])

        expect(@response_body_data).to have_key("deleted_at")
        expect(@response_body_data["deleted_at"]).to be_nil

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at")
        expect(@response_body_data["updated_at"]).to be_a(String)

        expect(@response_body_data).to have_key("system_controller_actions_id")
        expect(@response_body_data["system_controller_actions_id"]).to be_a(Numeric)
    end
end

RSpec.describe "PUT:/administration/role_descriptors/:id/privilege_actions/:id.json", type: :request do

    include_context "user authentication"

    before(:all) do   
        @role_descriptor = create(:role_descriptor, account: @user.account) 
        @privilege_action = create(:privilege_action, role_descriptors_id: @role_descriptor.id)
        @new_data = attributes_for(:invalid_privilege_action, role_descriptors_id: @role_descriptor.id)

        put("/administration/role_descriptors/#{@role_descriptor.id}/privilege_actions/#{@privilege_action.id}.json", params: {
            role_descriptor_privilege_action: @new_data
        })
    end

    include_examples "error standard json response"

    it "is expected to respond with a error when params are nil" do
        expect(@response_body["error"]).to be_a(Hash)
        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_an(Array)
    end
end

RSpec.describe "PUT:/administration/role_descriptors/:id/privilege_actions/:id.json", type: :request do
    let!(:account){ create(:account) }
    let(:login) { "/login" }

    before do
        @role_descriptor = create(:role_descriptor, account: account) 
        @privilege_action = create(:privilege_action, role_descriptors_id: @role_descriptor.id)
        @new_data = attributes_for(:invalid_privilege_action, role_descriptors_id: @role_descriptor.id)

        put("/administration/role_descriptors/#{@role_descriptor.id}/privilege_actions/#{@privilege_action.id}.json", params: {
            role_descriptor_privilege_action: {}
        })
    end

    it "is expected to respond with error when all required params are nil" do
        expect(response).to redirect_to(login)
    end
end