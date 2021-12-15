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


RSpec.describe 'POST:/administration/role_descriptors.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @role_descriptor = attributes_for(:role_descriptor, account: @user.account)

        post('/administration/role_descriptors.json', params: {
            role_descriptor: @role_descriptor
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to create a new role descriptor' do
        expect(@response_body['data']['name']).to eql(@role_descriptor[:name])
        expect(@response_body['data']['description']).to eql(@role_descriptor[:description])
    end
end


RSpec.describe 'POST:/administration/role_descriptors.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @role_descriptor = attributes_for(:invalid_r_d, account: @user.account)

        post('/administration/role_descriptors.json', params: {
            role_descriptor: @role_descriptor
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

RSpec.describe 'POST:/administration/role_descriptors.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @role_descriptor = attributes_for(:empty_str_r_d, account: @user.account)

        post('/administration/role_descriptors.json', params: {
            role_descriptor: @role_descriptor
        })
    end

    include_examples 'error standard json response'

    it "is expected to respond with error when params are empty strings" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)

        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end

RSpec.describe 'POST:/administration/role_descriptors.json', type: :request do
    before(:all) do
        post('/administration/role_descriptors.json', params: {
            role_descriptor: {}
        })
    end

    it "is expected to redirecto to login when user is not authenticated" do
        expect(response).to redirect_to("/login")
    end
end