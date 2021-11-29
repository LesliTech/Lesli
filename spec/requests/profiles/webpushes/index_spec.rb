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

RSpec.describe 'GET:/administration/profile/webpushes.json', type: :request do

    include_context 'request user authentication'
    
    it 'is expected to respond with all webpush registrations' do

        Faker::Number.between(from: 1, to: 5).times do 
            @current_user.webpushes.create(
                :endpoint => 'http://lesli.cloud/api/bell/notifications.json',
                :auth_key => 'ABC123',
                :p256dh_key => '123ABC'
            )
        end

        get '/administration/profile/webpushes.json'

        expect_json_response_successful

        expect_count = @current_user.webpushes.all.size

        response_body = response_json

        expect(response_body['data'].length).to eql(expect_count)

    end
end
