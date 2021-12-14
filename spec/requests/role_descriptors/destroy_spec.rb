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

RSpec.describe "DELETE:/administration/role_descriptors/:id.json", type: :request do

    include_context "user authentication"

    before(:all) do
        @role_descriptor = create(:role_descriptor, account: @user.account)

        delete "/administration/role_descriptors/#{@role_descriptor.id}.json"
    end

    include_examples "successful standard json response"

    it "is expected to have deleted a role descriptor successfully" do
        expect(@response_body_data).to be_nil
    end
end

RSpec.describe "DELETE:/administration/role_descriptors/:id.json", type: :request do

    include_context "user authentication"

    before(:all) do
        @invalid_id = create(:role_descriptor, account: @user.account).id + 1

        delete "/administration/role_descriptors/#{@invalid_id}.json"
    end

    include_examples "not found standard json response"

    it "is expected to respond with not found when a record does not exist" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
        
        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_an(Array)
    end
end

