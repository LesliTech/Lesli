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


=begin
require 'lesli_request_helper'
require 'spec_helper'   
require 'byebug'


RSpec.describe "PUT:/password.json", type: :request do
    before(:all) do
        @user = User.find_by(:email => "test@lesli.cloud")
        @token = @user.generate_password_reset_token

        @user = {    
            password: "my_new_password123",
            password_confirmation: "my_new_password123",
            reset_password_token: @token
        }

        put("/password.json", params: { user: @user })
    end

    it "is expected to respond with successful standard json response" do
        expect_json_response_successful
    end
end

RSpec.describe "PUT:/password.json", type: :request do
    before(:all) do
        @user = {    
            password: "",
            password_confirmation: "",
            reset_password_token: ""
        }

        put("/password.json", params: { user: @user })
    end

    it "is expected to respond with error standard json response" do
        expect_json_response_error
    end

    it "is expected to respond with error when no valid params are sent" do
        expect(response_error).to be_a(Hash)
        expect(response_error).to have_key("message")
        expect(response_error["message"]).to be_a(String)

        expect(response_error).to have_key("details")
        expect(response_error["details"]).to be_an(Array)
    end
end
=end
