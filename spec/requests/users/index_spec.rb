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

RSpec.describe 'GET:/administration/users.json', type: :request do

    include_context 'request user authentication'
    
    it 'is expected to respond with all the users' do

        get '/administration/users.json', params: {
            :perPage => 1000
        }

        expect_json_response_successful

        expect_count = @current_user.account.users
            .joins(:detail, :user_roles)
            .group("users.id, user_roles.users_id")
            .map(&:id).uniq.count

        response_body = response_json
        
        expect(response_body["data"]["users_count"]).to eql(expect_count)
        expect(response_body["data"]["users"].length).to eql(expect_count)

    end
end

RSpec.describe 'GET:/administration/users/list.json', type: :request do

    include_context 'request user authentication'

    it "is expected to respond with total of user with a specific role" do

        ['owner', 'sysadmin', 'api', 'guest', 'limited'].each do |role|
    
            get "/administration/users/list.json?role=#{role}"
            
            expect_json_response_successful
    
            users_by_role_in_database = @current_user.account.users.joins(:roles).where("roles.name = ?", role).count

            expect(response_data.count).to eql(users_by_role_in_database)
    
        end

    end

end
