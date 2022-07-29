=begin
    Copyright (c) 2021, all rights reserved.
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
RSpec.describe "GET://administration/profile/subscriptions/options.json", type: :request, :unless => defined?(DeutscheLeibrenten) do
    describe "GET:/administration/profile/subscriptions/options.json", type: :request do
        include_context "request user authentication"
        it "is expected to respond a hash not empty whit diferent key value" do
            get("/administration/profile/subscriptions/options.json")
            expect_response_with_successful
            expect(response_body).not_to be_nil 
            expect(response_body).to be_an(Hash)
            expect(response_body.length).to be >= 1
            expect(response_body.keys.sort).to eq ["engines", "notification_types"].sort
        end

        it "validate engines list" do 
            get("/administration/profile/subscriptions/options.json")
            expect_response_with_successful
            expect(response_body["engines"]).not_to be_nil 
            expect(response_body["engines"]).to be_an(Array)
            if response_body["engines"].length >= 1 then
                expect(response_body["engines"].first.keys.sort).to eq ["value", "text"].sort
            end
        end

        it "validate notification_types list" do 
            get("/administration/profile/subscriptions/options.json")
            expect_response_with_successful
            expect(response_body["notification_types"]).not_to be_nil 
            expect(response_body["notification_types"]).to be_an(Hash)
            expect(response_body["notification_types"].keys.sort).to eq ["email", "mobiledialog", "mobilepush", "push", "webpush"].sort
        end
    end
end
