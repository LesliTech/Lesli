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


#
RSpec.describe 'GET:/administration/profile/notifications.json', type: :request do
    
    include_context 'request user authentication'
    
    let(:local_count) { Courier::Bell::Notification.count(@current_user, true) }
    let(:remote_count) do
        remote_count = response_body['data']['pagination']['count_total'] if defined?(CloudBell)
        remote_count = response_body['data'].size if not defined?(CloudBell)
        remote_count
    end
    let(:response_body) { response_json }

    before do 
        # register a notification to the user, so we have at least one active notification
        Courier::Bell::Notification.new(@current_user, "notification from rspec")

        # ask for the list of notifications fo the current user
        get '/administration/profile/notifications.json'
    end

    it 'is expected to respond with all the user\'s notifications' do
        expect_json_response_successful
        expect(local_count).to be >=(1) if  defined?(CloudBell)
        expect(remote_count).to be >=(1) if defined?(CloudBell)

        expect(remote_count).to eql(local_count)
    end

end

RSpec.describe "GET:/administration/profile/notifications.json", type: :request do
    let(:login) { "/login?r=/administration/profile/notifications.json" }
    before(:all) { get "/administration/profile/notifications.json" }

    it "is expected to redirect to login when user is not authenticated" do
        expect(response).to redirect_to(login)
    end
end
