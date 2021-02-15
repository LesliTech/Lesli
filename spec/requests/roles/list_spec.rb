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
    
    before(:all) do
        get '/administration/roles/list.json' 
    end

    include_examples 'successful standard json response'

    it 'is expected to respond with the roles the user has level to work with' do

        # get the roles user has level to work with
        roles_count = @user.account.roles
        .where("object_level_permission <= ?", @user.roles.map(&:object_level_permission).max())
        .count

        expect(@response_body["data"].count).to eql(roles_count)
    end
end
