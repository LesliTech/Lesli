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


RSpec.describe "POST:/", type: :request do

    before(:all) do
        @password = Faker::Alphanumeric.alpha(number: 20)

        @registration = {
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password
        }

        post "/", params: { user: @registration }
    end

    if Rails.application.config.lesli[:security][:allow_registration]
        it "is expected to respond with successful standard json response" do
            expect_json_response_successful
        end

        it "is expected to register a new user through registrations controller" do
            expect(response_data).to be_nil
        end
    else
        it "is expected to respond with error standard json response" do
            expect_json_response_error

            expect(response_error).to be_a(Hash)
            expect(response_error).to have_key("message")
            expect(response_error["message"]).to be_a(String)
            expect(response_error["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        end
    end
end

RSpec.describe "POST:/", type: :request do

    before(:all) do

        @registration = {
            email: "",
            password: "",
            password_confirmation: ""
        }

        post "/", params: { user: @registration }
    end

    if Rails.application.config.lesli[:security][:allow_registration]
        it "is expected to respond with error standard json response" do
            expect_json_response_error
        end

        it "is expected to respond with error when params to register are blank" do
            expect(response_error).to be_a(Hash)
            expect(response_error).to have_key("message")
            expect(response_error["message"]).to be_a(String)

            expect(response_error).to have_key("details")
            expect(response_error["details"]).to be_an(Array)
        end
    else
        it "is expected to respond with error standard json response" do
            expect_json_response_error

            expect(response_error).to be_a(Hash)
            expect(response_error).to have_key("message")
            expect(response_error["message"]).to be_a(String)
            expect(response_error["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        end
    end
end

RSpec.describe "POST:/", type: :request do

    before(:all) do

        @registration = {
            email: nil,
            password: nil,
            password_confirmation: nil
        }

        post "/", params: { user: @registration }
    end

    if Rails.application.config.lesli[:security][:allow_registration]
        it "is expected to respond with error standard json response" do
            expect_json_response_error
        end

        it "is expected to respond with error when params to register are nil" do
            expect(response_error).to be_a(Hash)
            expect(response_error).to have_key("message")
            expect(response_error["message"]).to be_a(String)

            expect(response_error).to have_key("details")
            expect(response_error["details"]).to be_an(Array)
        end
    else
        it "is expected to respond with error standard json response" do
            expect_json_response_error

            expect(response_error).to be_a(Hash)
            expect(response_error).to have_key("message")
            expect(response_error["message"]).to be_a(String)
            expect(response_error["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        end
    end
end
