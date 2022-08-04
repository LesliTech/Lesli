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

require "lesli_request_helper"
RSpec.describe "Tests for Lesli3", type: :request, :unless => defined?(DeutscheLeibrenten) do
    describe "PUT: /administration/profile/notifications/:id.json", type: :request do
        include_context "request user authentication"
        user = FactoryBot.attributes_for(:user)
        puts "user #{user}"
        puts "user id #{user[:account]["id"]} "

        notification = FactoryBot.attributes_for(:notification)
        puts "#{notification}"
        #share example
        it "is expected pass share example response with successful" do
            put("/administration/profile/notifications/#{user[:account]["id"]}.json",  params: {
                profile_notification: { id: 3, name: "juanito"}
            })

            puts "respuesta #{response_body}"
            expect_response_with_successful
        end
    end
end

