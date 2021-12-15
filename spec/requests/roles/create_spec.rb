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


RSpec.describe 'POST:/administration/roles.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @user_role_level_max = @user.roles.map(&:object_level_permission).max()
        @role = attributes_for(:role, account: @user.account, object_level_permission: @user_role_level_max - 10)

        post("/administration/roles.json", params: {
            role: @role
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to create a new role' do
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)
        expect(@response_body_data["id"]).to be >= 1

        expect(@response_body_data).to have_key("active")
        expect(@response_body_data["active"]).to be_truthy

        expect(@response_body_data).to have_key("name")
        expect(@response_body_data["name"]).to be_a(String)
        expect(@response_body_data["name"]).to eql(@role[:name])

        expect(@response_body_data).to have_key("object_level_permission")
        expect(@response_body_data["object_level_permission"]).to be_a(Numeric)
        expect(@response_body_data["object_level_permission"]).to eql((@user_role_level_max - 10))

        expect(@response_body_data).to have_key("default_path")
        expect(@response_body_data["default_path"]).to be_nil

        expect(@response_body_data).to have_key("only_my_data")
        expect(@response_body_data["only_my_data"]).to be_falsey

        expect(@response_body_data).to have_key("code")
        expect(@response_body_data["code"]).to be_a(String)

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at")
        expect(@response_body_data["updated_at"]).to be_a(String)

        expect(@response_body_data).to have_key("deleted_at")
        expect(@response_body_data["deleted_at"]).to be_nil
    end
end


RSpec.describe 'POST:/administration/roles.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @user_role_level_max = @user.roles.map(&:object_level_permission).max()
        @role = attributes_for(:role, account: @user.account, object_level_permission: @user_role_level_max)
        post("/administration/roles.json", params: {
            role: @role
        })
    end

    include_examples 'error standard json response'

    it 'is expected to fail creating a new role with same object level permission' do
        expect(@response_body["successful"]).to eql(false)
    end
end


RSpec.describe 'POST:/administration/roles.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @user_role_level_max = @user.roles.map(&:object_level_permission).max()
        @role = attributes_for(:role, account: @user.account, object_level_permission: @user_role_level_max + 10)
        post("/administration/roles.json", params: {
            role: @role
        })
    end

    include_examples 'error standard json response'

    it 'is expected to fail creating a new role with object level permission too high' do
        expect(@response_body["successful"]).to eql(false)
    end
end

RSpec.describe "POST:/administration/roles.json", type: :request do
    include_context 'user authentication'

    before(:all) do
        @user_role_level_max = @user.roles.map(&:object_level_permission).max()
        @role = attributes_for(:invalid_role, account: @user.account, object_level_permission: nil) # the rest of params are nil

        post("/administration/roles.json", params: {
            role: @role
        })
    end

    include_examples 'error standard json response'

    it "is expected to respond with error when params are nil" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)

        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end
