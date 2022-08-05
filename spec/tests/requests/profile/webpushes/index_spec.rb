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
    describe "GET:/administration/profile/webpushes.json", type: :request do
        include_context "request user authentication"
        let!(:webpush) { FactoryBot.create(:webpush, user: @current_user) }
        #share example
        it "is expected pass share example response with successful" do
            get("/administration/profile/webpushes.json")
            expect_response_with_successful

            LC::Debug.deprecation(response_body)
        end

        #validate response hash type and type element
        it "is expected to respond an array whit hash type elements" do
            get("/administration/profile/webpushes.json")

            expect_response_with_successful

            LC::Debug.deprecation(response_body)

            expect(response_body).not_to be_nil 
            expect(response_body).to be_kind_of(Array)
            expect(response_body.first).to be_an(Hash)
            expect(response_body.length).to be >= 1
        end

        #validate fist element keyvalues
        it "is expected to validate type data of hash elements" do 
            get("/administration/profile/webpushes.json")

            expect_response_with_successful

            LC::Debug.deprecation(response_body)

            expect(response_body.first).to have_key("id")
            expect(response_body.first).to have_key("user_agent")
            expect(response_body.first).to have_key("created_at_date")
            expect(response_body.first).to have_key("updated_at_date")
            expect(response_body.first).to have_key("active")
            expect(response_body.first["id"]).to be_kind_of(Numeric)
            expect(response_body.first["user_agent"]).to be_a(String)
            expect(response_body.first["created_at_date"]).to be_a(String)
            expect(response_body.first["updated_at_date"]).to be_a(String)
            expect(response_body.first["active"]).to be_in([true, false])
        end
    end
end
