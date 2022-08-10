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
    describe "GET:/administration/profile/subscriptions/options.json", type: :request do
        include_context "request user authentication"

        it "is expected to respond a hash not empty with diferent key value" do
            get("/administration/profile/subscriptions/options.json")

            #share examples
            expect_response_with_successful

        end 

        it "is expected to respond a hash not empty with diferent key value" do
            get("/administration/profile/subscriptions/options.json")

            #share examples
            expect_response_with_successful

            #validate response hash not null and keywords
            expect(response_body).not_to be_nil 
            expect(response_body).to be_an(Hash)
            expect(response_body.length).to be >= 1
            expect(response_body.keys.sort).to eq ["engines", "notification_types"].sort
        end

        #validate engines array
        it "is expected to validate engines list" do 
            get("/administration/profile/subscriptions/options.json")

            #share examples
            expect_response_with_successful

            #validate engines array
            expect(response_body["engines"]).to be_an(Array)
        end

        #validate notification type hash
        it "is expected to validate notification_types list" do 
            get("/administration/profile/subscriptions/options.json")

            #share examples
            expect_response_with_successful

            #validate notification type hash
            expect(response_body["notification_types"]).to be_an(Hash)
        end
    end
end
