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
    describe "POST:/administration/profile/webpushes.json", type: :request do
        include_context "request user authentication"
        profile_webpush_params = FactoryBot.attributes_for(:webpush)
       
        #share example
         it "is expected pass share example response with successful" do
            post("/administration/profile/webpushes.json", params: {
                profile_webpush: profile_webpush_params
            })
            expect_response_with_successful
        end

        #validate response hash type and type element
        it "is expected to respond a hash type element" do
            post("/administration/profile/webpushes.json", params: {
                profile_webpush: profile_webpush_params
            })
            expect(response_body).not_to be_nil 
            expect(response_body).to be_an(Hash)
            expect(response_body.length).to be >= 1
        end

        #validate fist element keyvalues
        it "validate type data of hash element" do 
            post("/administration/profile/webpushes.json", params: {
                profile_webpush: profile_webpush_params
            })
            expect(response_body.keys.sort).to eq ["active", "auth_key", "created_at", "deleted_at", "endpoint", "id", "p256dh_key", "updated_at", "user_agent", "users_id"].sort
            expect(response_body["id"]).to be_kind_of(Numeric)
            expect(response_body["users_id"]).to be_kind_of(Numeric)
            expect(response_body["user_agent"]).to be_a(String)
            expect(response_body["created_at"]).to be_a(String)
            expect(response_body["endpoint"]).to be_a(String)
            expect(response_body["updated_at"]).to be_a(String)
            expect(response_body["deleted_at"]).to be_nil
            expect(response_body["auth_key"]).to be_a(String)
            expect(response_body["p256dh_key"]).to be_a(String)
            expect(response_body["active"]).to be_in([true, false])
        end
    end
end
