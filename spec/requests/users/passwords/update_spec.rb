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


require 'rails_helper'
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

    include_examples "successful standard json response"
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

    include_examples "error standard json response"

    it "is expected to respond with error when no valid params are sent" do
        expect(@response_body["error"]).to be_a(Hash)
        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)

        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_an(Array)
    end
end