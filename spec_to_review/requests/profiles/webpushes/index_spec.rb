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
    
    let(:random_number) { Faker::Number.between(from: 1, to: 5) }
    let!(:webpushes) { create_list(:webpush, random_number, users_id: @current_user.id) }
    let(:expect_count) { @current_user.webpushes.all.size }
    let(:response_body) { response_json }

    before { get '/administration/profile/webpushes.json' }

    it 'is expected to respond with all webpush registrations' do
        expect_json_response_successful

        expect(response_body['data'].length).to be >= random_number
        expect(response_body['data'].length).to eql(expect_count)
    end
end
