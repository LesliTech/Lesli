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


RSpec.describe "PUT:/", type: :request do
    include_context 'request user authentication'

    before do
        @password = Faker::Alphanumeric.alpha(number: 20)

        # valid params
        @registration = {
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password
        }

        put "/", params: { user: @registration }
    end

    it "is expected to respond with successful standard json response" do
        expect_json_response_successful
    end
end


RSpec.describe "PUT:/", type: :request do
    include_context 'request user authentication'

    before do
        @password = Faker::Alphanumeric.alpha(number: 20)

        # empty strings params
        @registration = {
            email: "",
            password: "",
            password_confirmation: ""
        }

        put "/", params: { user: @registration }
    end

    it "is expected to respond with error standard json response" do
        expect_json_response_error
    end
end


RSpec.describe "PUT:/", type: :request do
    include_context 'request user authentication'

    before do
        @password = Faker::Alphanumeric.alpha(number: 20)

        # nil params
        @registration = {
            email: nil,
            password: nil,
            password_confirmation: nil
        }

        put "/", params: { user: @registration }
    end

    it "is expected to respond with error standard json response" do
        expect_json_response_error
    end
end