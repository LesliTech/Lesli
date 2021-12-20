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


RSpec.describe 'DELETE:/administration/roles.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @role = create(:role, account: @user.account, object_level_permission: 10)

        delete "/administration/roles/#{@role.id}.json"
    end

    include_examples "successful standard json response"

    it "is expected to have deleted a role successfully" do
        expect(@response_body_data).to be_nil
    end
end

RSpec.describe 'DELETE:/administration/roles.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @invalid_id = create(:role, account: @user.account).id + 1

        delete "/administration/roles/#{@invalid_id}.json"
    end

    include_examples "not found standard json response"

    it "is expected to respond with error when a role does not exist" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)

        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end

RSpec.describe 'DELETE:/administration/roles.json', type: :request do
    let(:login) { "/login" }

    before(:all) do
        @account = create(:account)
        @role = create(:role, account: @account)

        delete "/administration/roles/#{@role.id}.json"
    end

    it "is expected to redirect to login when user is not authenticated" do
        expect(response).to redirect_to(login)
    end
end