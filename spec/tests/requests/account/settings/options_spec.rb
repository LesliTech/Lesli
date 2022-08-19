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
    describe "GET:/administration/account/settings/options.json", type: :request do
        include_context "request user authentication"

        it "is expected to respond succesful" do
            get("/administration/account/settings/options.json")

            #share examples
            expect_response_with_successful
        end 

        it "is expected to respond with keyvalues and format" do
            get("/administration/account/settings/options.json")

            #share examples
            expect_response_with_successful

            #keyvalues
            expect(response_body).to be_an(Hash)

            #time zone array validation
            expect(response_body).to have_key("time_zones")
            expect(response_body["time_zones"]).to be_an(Array)
            expect(response_body["time_zones"].first).to have_key("value")
            expect(response_body["time_zones"].first["value"]).to be_an(String)
            expect(response_body["time_zones"].first).to have_key("text")
            expect(response_body["time_zones"].first["text"]).to be_an(String)

            #days into week array validation
            expect(response_body).to have_key("days_into_week")
            expect(response_body["days_into_week"]).to be_an(Array)
            expect(response_body["days_into_week"].first).to have_key("value")
            expect(response_body["days_into_week"].first["text"]).to be_an(String)
            expect(response_body["days_into_week"].first).to have_key("text")
            expect(response_body["days_into_week"].first["text"]).to be_an(String)
        end 
    end
end




