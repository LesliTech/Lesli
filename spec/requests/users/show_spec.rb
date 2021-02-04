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


RSpec.describe 'GET:/administration/users/:id.json', type: :request do
    include_context 'user authentication'
    
    before(:all) do
        @user = User.find_by(:email => "test@lesli.cloud")
        get "/administration/users/#{@user.id}.json"
    end

    include_examples 'successful standard json response'

    it 'is expected to respond with full user object' do
        expect(@response_body["data"]["id"]).to eql(@user.id)
        expect(@response_body["data"]["email"]).to eql(@user.email)
        expect(@response_body["data"]["active"]).to eql(@user.active)
        expect(@response_body["data"]["full_name"]).to eql(@user.full_name)

        expect(@response_body["data"]["detail_attributes"]["first_name"]).to eql(@user.detail.first_name)
        expect(@response_body["data"]["detail_attributes"]["last_name"]).to eql(@user.detail.last_name)
    end
end



RSpec.describe 'GET:/administration/users/:id.json', type: :request do
    include_context 'user authentication'
    
    before(:all) do
        get "/administration/users/0.json"
    end

    include_examples 'not found standard json response'

    it 'is expected to respond with user not found' do
        expect(@response_body["successful"]).to eql(false)
    end
end


