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
RSpec.describe 'PUT:/administration/profile/notifications/:id.json', type: :request do

    include_context 'request user authentication'

    it 'is expected to respond with notification id marked as read' do

        # register a notification to the user, so we have at least one active notification
        notification = Courier::Bell::Notification.new(@current_user, "notification from rspec")

        # if CloudBell is not installed we'll work with zero as ID
        notification_id = notification
        notification_id = notification[:id] if defined?(CloudBell)

        # mark notification as read
        put "/administration/profile/notifications/#{ notification_id }.json"

        expect_json_response_successful

        response_body = response_json

        expect(response_body['data']).to eql(notification_id)

    end

end


RSpec.describe 'PUT:/administration/profile/notifications/all.json', type: :request do

    include_context 'request user authentication'

    it 'is expected to respond with total notifications marked as read' do

        # register some notifications to the user, so we have at least one active notification
        (1..12).each do |i|
            Courier::Bell::Notification.new(@current_user, "notification from rspec #{ i }")
        end

        # get number of active notifications
        local_count = Courier::Bell::Notification.count(@current_user, true)

        # mark notification as read
        put "/administration/profile/notifications/all.json"

        expect_json_response_successful

        response_body = response_json

        expect(response_body['data']).to eql(local_count)

    end
end


RSpec.describe 'PUT:/administration/profile/notifications/:id.json', type: :request do

    include_context 'request user authentication'

    it 'is expected to respond with total notifications marked as read' do

        # register a notification to all the users of a rol
        notifications = Courier::Bell::Notification.new(nil, "notification from rspec", role_names: "owner")

        # get number of active notifications
        local_count = Courier::Bell::Notification.count(@current_user, true)

        # mark notification as read
        put "/administration/profile/notifications/all.json"

        expect_json_response_successful

        response_body = response_json

        expect(response_body['data']).to eql(local_count)

    end
end

