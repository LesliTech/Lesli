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


RSpec.describe 'GET:/administration/roles/list.json', type: :request do
    include_context 'user authentication'
    
    # get the roles user has level to work with
    let(:roles_count) do
        @user.account.roles
        .where("object_level_permission <= ?", @user.roles.map(&:object_level_permission).max())
        .count
    end

    before(:all) do
        get '/administration/roles/list.json' 
    end

    include_examples 'successful standard json response'

    it 'is expected to respond with the roles the user has level to work with' do
        expect(@response_body_data).to be_an(Array)
        expect(@response_body_data.count).to eql(roles_count)

        expect(@response_body_data.first).to be_a(Hash)
        expect(@response_body_data.first).to have_key("id")
        expect(@response_body_data.first["id"]).to be_a(Numeric)

        expect(@response_body_data.first).to have_key("name")
        expect(@response_body_data.first["name"]).to be_a(String)

        expect(@response_body_data.first).to have_key("object_level_permission")
        expect(@response_body_data.first["object_level_permission"]).to be_a(Numeric)
    end
end


RSpec.describe 'GET:/administration/roles/list.json', type: :request do
    let(:login) { "/login?r=/administration/roles/list.json" }
    before(:all) do
        get '/administration/roles/list.json' 
    end

    it 'is expected to redirect to login when user is not authenticated' do
        expect(response).to redirect_to(login)
    end
end

