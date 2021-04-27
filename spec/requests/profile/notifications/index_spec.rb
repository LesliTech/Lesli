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


RSpec.describe 'GET:/administration/profile/notifications.json', type: :request do
    include_context 'user authentication'
    
    before(:all) do
        # register a notification to the user, so we have at least one active notification
        Courier::Bell::Notification.new(@user, "notification from rspec")

        # ask for the list of notifications fo the current user
        get '/administration/profile/notifications.json'
    end

    include_examples 'successful standard json response'

    it 'is expected to respond with all the user\'s notifications' do

        local_count = Courier::Bell::Notification.count(@user, true)

        remote_count = @response_body["data"]["pagination"]["count_total"] if defined?(CloudBell)
        remote_count = @response_body["data"].size if not defined?(CloudBell)

        expect(remote_count).to eql(local_count)
        expect(remote_count).to be >=(local_count)

    end
end
