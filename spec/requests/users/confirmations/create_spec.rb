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
require 'spec_helper'   
require 'byebug'


RSpec.describe "POST:/confirmation.json", type: :request do
    include_context 'request user authentication'

    before(:all) do
        @new_user = create(:user)

        post("/confirmation.json", params: { user: { email: @new_user.email } })
    end

    it "is expected to respond with successful standard json response" do
        expect_json_response_successful
    end

    it "is expected to return with user confirmation created successfully" do
        expect(@resopnse_body_data).to be_nil
    end
end

RSpec.describe "POST:/confirmation.json", type: :request do

    before(:all) do
        post "/confirmation.json", params: { user: { email: "" } } 
    end

    it "is expected to respond with successful error json response" do
        expect_json_response_error
    end

    it "is expected to return with error when the email given is blank" do
        expect(response_error).to be_a(Hash)
        expect(response_error).to have_key("message")
        expect(response_error["message"]).to be_a(String)

        expect(response_error).to have_key("details")
        expect(response_error["details"]).to be_an(Array)
    end
end


RSpec.describe "POST:/confirmation.json", type: :request do

    before(:all) do
        post "/confirmation.json", params: { user: { email: Faker::Internet.email } } 
    end

    it "is expected to respond with successful error json response" do
        expect_json_response_error
    end

    it "is expected to return with not found when the email does not exist in the DB" do
        expect(response_error).to be_a(Hash)
        expect(response_error).to have_key("message")
        expect(response_error["message"]).to be_a(String)
        
        expect(response_error).to have_key("details")
        expect(response_error["details"]).to be_an(Array)
    end
end