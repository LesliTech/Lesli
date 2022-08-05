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

require "lesli_request_helper"

RSpec.describe "Tests for Lesli3", type: :request, :unless => defined?(DeutscheLeibrenten) do
    describe "PUT:/administration/profile/notifications/:id.json", type: :request do
        include_context 'request user authentication'

        #notification_id =   Courier::Bell::Notification.new(@current_user, "notification from test")[:id][0]
        let(:notification_id) { Courier::Bell::Notification.new(@current_user, "notification from rspec")[:id][0] }
        #puts "notificacion #{Courier::Bell::Notification.new(@current_user, "notification from rspec")}" 
        puts "notificacion id #{:notification_id}"
        puts "URL /administration/profile/notifications/#{ :notification_id }"
        #share examples
        it "is expected to respond a hash not empty whit diferent key value" do
            put("/administration/profile/notifications/#{ notification_id }.json")
            puts "respuesta #{response_body}"
            expect_response_with_successful
        end 
    end
end
