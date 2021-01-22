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


RSpec.describe 'GET:/administration/users.json', type: :request do
    include_context 'user authentication'
    
    before(:all) do
        get '/administration/users.json' 
    end

    include_examples 'successful standard json response'


    it 'is expected to respond with all the users' do
        expect(@response_body["data"]["users_count"]).to eql(@user.account.users.count)
    end
end

RSpec.describe 'GET:/administration/users/list?role=owner', type: :request do
    include_context 'user authentication'

    before(:all) do
        @role = "owner"
        get "/administration/users/list.json?role=#{ @role }"
    end
    
    include_examples 'successful standard json response'



    it 'is expected to respond with total of user with a specific role' do
        expect(@response_body["data"].length).to eql(@user.account.users.joins(:roles).where("roles.name = ?", @role).count)
    end

    it 'is expected to respond with users with a specific role' do
        roles_count = 0
        @response_body["data"].each do |user|
            role_existance = user["roles"].select do |role|
                role["name"] == @role
            end

            roles_count += 1 if role_existance.length > 0
        end
        expect(roles_count).to eql(@response_body["data"].length)
    end

end
