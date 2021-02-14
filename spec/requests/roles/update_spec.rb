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


RSpec.describe 'PUT:/administration/roles.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @role = @user.account.roles.order(object_level_permission: :asc).first
        @role_active = false
        put("/administration/roles/#{@role.id}.json", params: {
            role: {
                active: @role_active
            }
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to update a role' do
        expect(@response_body["data"]["id"]).to eql(@role.id)
        expect(@response_body["data"]["name"]).to eql(@role.name)
        expect(@response_body["data"]["active"]).to eql(@role_active)
        expect(@response_body["data"]["object_level_permission"]).to eql(@role.object_level_permission)
    end
end


RSpec.describe 'PUT:/administration/roles.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @role_name = Faker::Artist.name
        @role = @user.account.roles.order(object_level_permission: :desc).first
        put("/administration/roles/#{@role.id}.json", params: {
            role: {
                name: @role_name
            }
        })
    end

    include_examples 'error standard json response'

    it 'is expected to fail updating a role with highest level' do
        expect(@response_body["successful"]).to eql(false)
    end
end


RSpec.describe 'PUT:/administration/roles.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @user_role_level_max = @user.roles.map(&:object_level_permission).max()
        @role_active = false
        @role = @user.account.roles.where(:object_level_permission => @user_role_level_max).first
        put("/administration/roles/#{@role.id}.json", params: {
            role: {
                active: @role_active
            }
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to update a role with same object level permission' do
        expect(@response_body["data"]["id"]).to eql(@role.id)
        expect(@response_body["data"]["name"]).to eql(@role.name)
        expect(@response_body["data"]["active"]).to eql(@role_active)
        expect(@response_body["data"]["object_level_permission"]).to eql(@role.object_level_permission)
    end
end
