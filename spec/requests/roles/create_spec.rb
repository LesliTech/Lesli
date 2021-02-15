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
        @role_name = Faker::Artist.name
        post("/administration/roles.json", params: {
            role: {
                name: @role_name,
                active: true,
                object_level_permission: (@user_role_level_max - 10)
            }
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to create a new role' do
        expect(@response_body["data"]["active"]).to eql(true)
        expect(@response_body["data"]["name"]).to eql(@role_name)
        expect(@response_body["data"]["object_level_permission"]).to eql((@user_role_level_max - 10))
    end
end


RSpec.describe 'POST:/administration/roles.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @user_role_level_max = @user.roles.map(&:object_level_permission).max()
        @role_name = Faker::Artist.name
        post("/administration/roles.json", params: {
            role: {
                name: @role_name,
                active: true,
                object_level_permission: @user_role_level_max
            }
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
        @role_name = Faker::Artist.name
        post("/administration/roles.json", params: {
            role: {
                name: @role_name,
                active: true,
                object_level_permission: (@user_role_level_max + 10)
            }
        })
    end

    include_examples 'error standard json response'

    it 'is expected to fail creating a new role with object level permission too high' do
        expect(@response_body["successful"]).to eql(false)
    end
end
