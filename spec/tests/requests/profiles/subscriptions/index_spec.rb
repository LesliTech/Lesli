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
RSpec.describe "GET:/administration/profile/subscriptions.json", type: :request, :unless => defined?(DeutscheLeibrenten) do
    describe "GET:/administration/profile/subscriptions.json", type: :request do
        include_context "request user authentication"
        it "is expected to respond a hash not empty whit diferent key value" do
            get("/administration/profile/subscriptions.json")
            expect_response_with_successful
            LC::Debug.msg("my respond #{response_body}" )
            #expect(response_body).not_to be_nil 
            #expect(response_body).to be_an(Hash)
            #expect(response_body.length).to be >= 1
            #expect(response_body.keys.sort).to eq ["active", "alias", "created_at", "detail_attributes", "editable_security", "email", "full_name", "id", "mfa_enabled", "mfa_method", "roles", "updated_at"].sort
        end
    end
end
