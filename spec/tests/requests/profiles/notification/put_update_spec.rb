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


        #share examples
        it "is expected to respond 0" do
            #puts "notificacion id #{notification_id}"
            #puts "URL /administration/profile/notifications/#{ notification_id }"
            put("/administration/profile/notifications/#{ notification_id }.json")
            puts "respuesta #{response_body}"
            notificacion_leer = Courier::Bell::Notification.read(@current_user, notification_id)
            puts " leer la notificacion #{Courier::Bell::Notification.read(@current_user, notification_id)}"
            expect_response_with_successful
            expect(response_body).to eql(0)
            
        end 
    end
end
