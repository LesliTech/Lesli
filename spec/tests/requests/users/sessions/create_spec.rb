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


require 'lesli_request_helper'

RSpec.describe "POST:/login.json", type: :request do

    it "is expected to respond with successful standard json response" do
        @new_user = FactoryBot.create(:user)
        post "/login.json", params: { user: { email: @new_user.email, password: @new_user.password } }
        expect_response_with_successful
    end

    it "is expected to respond with error standard json response" do
        post "/login.json", params: { user: { email: "", password: "" } }
        expect_response_with_error
        expect(response_body).to be_a(Hash)
        expect(response_body).to have_key("message")
        expect(response_body["message"]).to be_a(String)
    end

    it "is expected to respond with error when the credentials are invalid" do
        @new_user = FactoryBot.create(:user)
        post "/login.json", params: { user: { email: @new_user.email, password: "wrong password" } }
        expect_response_with_error
        expect(response_body).to be_a(Hash)
        expect(response_body).to have_key("message")
        expect(response_body["message"]).to be_a(String)
    end
end

RSpec.describe "POST:/login.json", type: :request do
    include_context "request user authentication"
    it "is expected to redirect to '/' route when the user is already logged" do
        post "/login.json", params: { user: { email: "", password: "" } }
        expect(response).to redirect_to("/")
    end
end
