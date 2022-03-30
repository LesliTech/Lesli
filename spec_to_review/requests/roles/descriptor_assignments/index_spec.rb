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

RSpec.describe "GET:/administration/roles/:id/descriptor_assignments.json", type: :request do
    include_context "user authentication"

    before(:all) do
        @role = create(:role, accounts_id: @user.account.id)
        @role_descriptor = create(:role_descriptor, account: @user.account)
        @descriptor_assignment = create_list(:role_descriptor_assignment, 10, roles_id: @role.id, role_descriptors_id: @role_descriptor.id)

        get "/administration/roles/#{@role.id}/descriptor_assignments.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with an array of role descriptor assignments" do
        expect(@response_body_data).to be_an(Array)
        expect(@response_body_data.length).to be >= 10

        expect(@response_body_data.last).to be_a(Hash)
        expect(@response_body_data.last).to have_key("id")
        expect(@response_body_data.last["id"]).to be_a(Numeric)
        expect(@response_body_data.last["id"]).to be >= 1

        expect(@response_body_data.last).to have_key("category")
        expect(@response_body_data.last["category"]).to be_a(String)

        expect(@response_body_data.last).to have_key("roles_id")
        expect(@response_body_data.last["roles_id"]).to be_a(Numeric)
        expect(@response_body_data.last["roles_id"]).to be >= 1

        expect(@response_body_data.last).to have_key("role_descriptors_id")
        expect(@response_body_data.last["role_descriptors_id"]).to be_a(Numeric)
        expect(@response_body_data.last["role_descriptors_id"]).to be >= 1

        expect(@response_body_data.last).to have_key("created_at")
        expect(@response_body_data.last["created_at"]).to be_a(String)

        expect(@response_body_data.last).to have_key("updated_at")
        expect(@response_body_data.last["updated_at"]).to be_a(String)

        expect(@response_body_data.last).to have_key("deleted_at")
        expect(@response_body_data.last["deleted_at"]).to be_nil
    end
end