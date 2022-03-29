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


RSpec.describe 'GET:/administration/roles/:id.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @role = create(:role, account: @user.account)

        get "/administration/roles/#{@role.id}.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with a valid role created" do
        expect(@response_body_data).to be_a(Hash)
        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be >= 1
        expect(@response_body_data["id"]).to eql(@role.id)
    end

    it "is expected to respond with all correct keys and data types of a role" do
        expect(@response_body_data).to have_key("name")
        expect(@response_body_data["name"]).to be_a(String)
        expect(@response_body_data["name"]).to eql(@role.name)

        expect(@response_body_data).to have_key("code")
        expect(@response_body_data["code"]).to be_a(String)

        expect(@response_body_data).to have_key("active")
        expect(@response_body_data["active"]).to be_truthy

        expect(@response_body_data).to have_key("default_path")
        expect(@response_body_data["default_path"]).to be_nil

        expect(@response_body_data).to have_key("only_my_data")
        expect(@response_body_data["only_my_data"]).to be_falsey

        expect(@response_body_data).to have_key("object_level_permission")
        expect(@response_body_data["object_level_permission"]).to be_a(Numeric)
        expect(@response_body_data["object_level_permission"]).to eql(@role.object_level_permission)

        expect(@response_body_data).to have_key("deleted_at")
        expect(@response_body_data["deleted_at"]).to be_nil

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at")
        expect(@response_body_data["updated_at"]).to be_a(String)

        expect(@response_body_data).to have_key("accounts_id")
        expect(@response_body_data["accounts_id"]).to be_a(Numeric)
        expect(@response_body_data["accounts_id"]).to eql(@role.accounts_id)
    end
end

RSpec.describe 'GET:/administration/roles/:id.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @invalid_id = create(:role, account: @user.account).id + 1

        get "/administration/roles/#{@invalid_id}.json"
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

RSpec.describe 'GET:/administration/roles/:id.json', type: :request do
    let(:login) { "/login?r=/administration/roles/#{@role.id}.json" }

    before(:all) do
        @account = create(:account)
        @role = create(:role, account: @account)

        get "/administration/roles/#{@role.id}.json"
    end

    it "is expected to redirect to login when user is not authenticated" do
        expect(response).to redirect_to(login)
    end
end