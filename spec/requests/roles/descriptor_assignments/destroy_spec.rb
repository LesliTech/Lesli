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

RSpec.describe "DELETE:/administration/roles/:id/descriptor_assignments/:id.json", type: :request do
    include_context "user authentication"

    let(:role_descriptor_assignment) do
        @user.account.roles.find_by(id: @role.id).descriptor_assignments.find_by(id: @descriptor_assignment.id) # should return nil
    end

    before(:all) do
        @role = create(:role, accounts_id: @user.account.id)
        @role_descriptor = create(:role_descriptor, account: @user.account)
        @descriptor_assignment = create(:role_descriptor_assignment, roles_id: @role.id, role_descriptors_id: @role_descriptor.id)

        delete "/administration/roles/#{@role.id}/descriptor_assignments/#{@descriptor_assignment.id}.json"
    end

    include_examples "successful standard json response"

    it "is expected to have deleted a role descriptor assignment" do
        expect(@response_body_data).to be_nil
        expect(role_descriptor_assignment).to be_nil
    end
end



RSpec.describe "DELETE:/administration/roles/:id/descriptor_assignments/:id.json", type: :request do
    include_context "user authentication"

    before(:all) do
        @role = create(:role, accounts_id: @user.account.id)
        @role_descriptor = create(:role_descriptor, account: @user.account)
        @invalid_id = create(:role_descriptor_assignment, roles_id: @role.id, role_descriptors_id: @role_descriptor.id).id + 1

        delete "/administration/roles/#{@role.id}/descriptor_assignments/#{@invalid_id}.json"
    end

    include_examples "not found standard json response"

    it "is expected to respond with error when the record does not exist" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
        
        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end