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

# include helpers, configuration & initializers for request tests
require 'lesli_request_helper'

RSpec.describe 'GET:/administration/users/:id.json', type: :request do

    include_context 'request user authentication'
    
    it 'is expected to respond with the first user created' do

        user = User.first

        get "/administration/users/#{user.id}.json"

        expect_json_response_successful

        expect(response_data["id"]).to eql(user.id)
        expect(response_data["email"]).to eql(user.email)
        expect(response_data["alias"]).to eql(user.alias)
        expect(response_data["active"]).to eql(user.active)
        expect(response_data["full_name"]).to eql(user.full_name)

    end

    it 'is expected to respond with the development user' do

        get "/administration/users/#{@current_user.id}.json"

        expect_json_response_successful

        expect(response_data["id"]).to eql(@current_user.id)
        expect(response_data["email"]).to eql(@current_user.email)
        expect(response_data["alias"]).to eql(@current_user.alias)
        expect(response_data["active"]).to eql(@current_user.active)
        expect(response_data["full_name"]).to eql(@current_user.full_name)

    end

end
