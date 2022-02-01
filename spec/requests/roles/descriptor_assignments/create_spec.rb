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


RSpec.describe "POST:/administration/roles/:id/descriptor_assignments.json", type: :request do
    include_context "user authentication"

    before(:all) do
        @role = create(:role, accounts_id: @user.account.id)
        @role_descriptor = create(:role_descriptor, account: @user.account)
        @descriptor_assignment = attributes_for(:role_descriptor_assignment, roles_id: @role.id, role_descriptors_id: @role_descriptor.id)

        post("/administration/roles/#{@role.id}/descriptor_assignments.json", params: { 
            role_descriptor_assignment: @descriptor_assignment
         })
    end

    include_examples "successful standard json response"

    it "is expected to respond a valid role descriptor assignment created" do
        expect(@response_body_data).to be_a(Hash)
        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)
        expect(@response_body_data["id"]).to be >= 1
    end

    it "is expected to have all the correct keys and data types" do
        expect(@response_body_data).to have_key("category")
        expect(@response_body_data["category"]).to be_a(String)
        expect(@response_body_data["category"]).to eql(@descriptor_assignment[:category])

        expect(@response_body_data).to have_key("roles_id")
        expect(@response_body_data["roles_id"]).to be_a(Numeric)
        expect(@response_body_data["roles_id"]).to eql(@role.id)

        expect(@response_body_data).to have_key("role_descriptors_id")
        expect(@response_body_data["role_descriptors_id"]).to be_a(Numeric)
        expect(@response_body_data["role_descriptors_id"]).to eql(@role_descriptor.id)

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at")
        expect(@response_body_data["updated_at"]).to be_a(String)

        expect(@response_body_data).to have_key("deleted_at")
        expect(@response_body_data["deleted_at"]).to be_nil
    end
end


RSpec.describe "POST:/administration/roles/:id/descriptor_assignments.json", type: :request do
    include_context "user authentication"

    before(:all) do
        @role = create(:role, accounts_id: @user.account.id)
        @role_descriptor = create(:role_descriptor, account: @user.account)
        @descriptor_assignment = attributes_for(:invalid_role_descriptor_assignment)

        post("/administration/roles/#{@role.id}/descriptor_assignments.json", params: { 
            role_descriptor_assignment: @descriptor_assignment
        })
    end

    include_examples "error standard json response"

    it "is expected to respond with error when data is invalid" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
        
        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end