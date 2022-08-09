=begin

Copyright (c) 2022, all rights reserved.

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
require 'lesli_request_helper'


RSpec.describe 'PUT:/administration/profile/notifications/all.json', type: :request do
    describe "PUT:/administration/profile/notifications/:id.json", type: :request do
    include_context 'request user authentication'

        let(:notifications) { Courier::Bell::Notification.new(@current_user, "notification from rspec", role_receiver_names: @current_user["role"])}
        @local_count = Courier::Bell::Notification.count(@current_user, true)

        it 'is expected to respond succesful' do
            put("/administration/profile/notifications/all.json")

            #share examples
            expect_response_with_successful
            #respond 0 because core doesnt handler notifications itself
            expect(response_body).to eql(0)
            
        end
    end
end
