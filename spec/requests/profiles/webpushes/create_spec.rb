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

RSpec.describe 'POST:/administration/profile/webpushes.json', type: :request do

    include_context 'request user authentication'
    
    it 'is expected to create a new webpush registrations' do

        webpush = {
            :endpoint => 'http://lesli.cloud/api/bell/notifications.json',
            :auth_key => 'ABC123',
            :p256dh_key => '123ABC'
        }

        post('/administration/profile/webpushes.json', params: {
            :profile_webpush => webpush
        })

        expect_json_response_successful

        response_body = response_json()
        response_data = response_data()

        expect(response_data['endpoint']).to eql(webpush[:endpoint])
        expect(response_data['auth_key']).to eql(webpush[:auth_key])
        expect(response_data['p256dh_key']).to eql(webpush[:p256dh_key])

    end
end
