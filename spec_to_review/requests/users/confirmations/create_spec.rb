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


RSpec.describe "POST:/confirmation.json", type: :request do
    include_context 'request user authentication'

    it "is expected to respond with successful standard json response" do
        @new_user = create(:user, confirm: false)

        post("/confirmation.json", params: { user: { email: @new_user.email } })

        puts response.body

        expect_json_response_successful

        expect(response_data).to be_nil
    end
end

RSpec.describe "POST:/confirmation.json", type: :request do
    include_context 'request user authentication'

    it "is expected to return with error when the email given is blank" do
        post "/confirmation.json", params: { user: { email: "" } } 

        expect_json_response_error

        expect(response_error).to be_a(Hash)
        expect(response_error).to have_key("message")
        expect(response_error["message"]).to be_a(String)

        expect(response_error).to have_key("details")
        expect(response_error["details"]).to be_an(Array)
    end
end


RSpec.describe "POST:/confirmation.json", type: :request do
    include_context 'request user authentication'

    it "is expected to return with not found when the email does not exist in the DB" do
        post "/confirmation.json", params: { user: { email: Faker::Internet.email } } 

        expect_json_response_error

        expect(response_error).to be_a(Hash)
        expect(response_error).to have_key("message")
        expect(response_error["message"]).to be_a(String)
        
        expect(response_error).to have_key("details")
        expect(response_error["details"]).to be_an(Array)
    end
end