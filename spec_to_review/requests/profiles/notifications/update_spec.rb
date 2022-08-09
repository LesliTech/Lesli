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

RSpec.describe 'PUT:/administration/profile/notifications/:id.json', type: :request do

    include_context 'request user authentication'

    let(:response_body) { response_json }
    # register a notification to the user, so we have at least one active notification
    # if CloudBell is not installed we'll work with zero as ID
    let(:notification_id) { Courier::Bell::Notification.new(@current_user, "notification from rspec")[:id][0] }

    before do
        # mark notification as read
        put "/administration/profile/notifications/#{ notification_id }.json"
    end

    it 'is expected to respond with notification id marked as read' do
        #expect_json_response_successful
        puts "respuesta notification by id #{response_body}"
        #expect(response_body['data']).to eql(notification_id)
    end

end


RSpec.describe 'PUT:/administration/profile/notifications/all.json', type: :request do

    include_context 'request user authentication'

    let(:response_body) { response_json }

    before do
        # register some notifications to the user, so we have at least one active notification
        (1..12).each do |i|
            Courier::Bell::Notification.new(@current_user, "notification from rspec #{ i }")
        end

        # get number of active notifications
        @local_count = Courier::Bell::Notification.count(@current_user, true)

        # mark notification as read
        put "/administration/profile/notifications/all.json"
    end

    it 'is expected to respond with total notifications marked as read' do
        #expect_json_response_successful
        puts "respuesta notification all 1 #{response_body}"
        #expect(response_body['data']).to eql(@local_count)
    end
end


RSpec.describe 'PUT:/administration/profile/notifications/:id.json', type: :request do

    include_context 'request user authentication'

    let(:response_body) { response_json }

    before do
        # register a notification to all the users of a rol
        notifications = Courier::Bell::Notification.new(@current_user, "notification from rspec", role_receiver_names: ["owner"])

        # get number of active notifications
        @local_count = Courier::Bell::Notification.count(@current_user, true)

        # mark notification as read
        put "/administration/profile/notifications/all.json"

        puts "respuesta notification all 2 #{response_body}"
    end

    it 'is expected to respond with total notifications marked as read' do
        expect_json_response_successful
        expect(response_body['data']).to eql(@local_count)
    end
end

RSpec.describe "GET:/administration/profile/notifications/:id.json", type: :request do
    let(:current_user) { User.first } 
    let(:login) { "/login" }
    let(:notification_id) { Courier::Bell::Notification.new(current_user, "notification from rspec")[:id][0] }
    before { put "/administration/profile/notifications/#{ notification_id }.json" }

    it "is expected to redirect to login when user is not authenticated" do
        puts "respuesta notification get #{response_body}"
        #expect(response).to redirect_to(login)
    end
end
