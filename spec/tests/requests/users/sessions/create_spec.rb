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
        expect_json_response_successful
    end

    it "is expected to respond with error standard json response" do
        post "/login.json", params: { user: { email: "", password: "" } }
        expect_json_response_error
        expect(response_error).to be_a(Hash)
        expect(response_error).to have_key("message")
        expect(response_error["message"]).to be_a(String)
    end

    it "is expected to respond with error when the credentials are invalid" do
        @new_user = FactoryBot.create(:user)
        post "/login.json", params: { user: { email: @new_user.email, password: "wrong password" } }
        expect_json_response_error
        expect(response_error).to be_a(Hash)
        expect(response_error).to have_key("message")
        expect(response_error["message"]).to be_a(String)
    end

    it "is expected to respond with error when params are not present" do
        # do request
        post "/login.json"

        # shared examples
        expect_json_response_error
    end

    it "is expected to respond with error when params are blank" do
        # do request
        post "/login.json", params: { user: { email: "", password: "" } }

        # shared examples
        expect_json_response_error
    end

    # Tests since MFA integration

    it "is expected to respond with successfull and redirect to /mfa/new view when a user has MFA enabled" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => "true")
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value => "email")

        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_successful
        
        # custom examples
        expect(response_data).to have_key("default_path") # this path should be something like /mfa/enter_code?key=ENCRYPTED_EMAIL
        expect(response_data["default_path"]).to be_a(String)
        expect(response_data["default_path"]).to include("/mfa/new?key=")
    end

    it "is expected to respond with successfull and do 'normal' login when MFA fields are exist but it is disabled" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => "false")
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value => "email")

        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_successful

        # custom examples
        expect(response_data).to have_key("default_path")
        expect(response_data["default_path"]).to be_nil
    end

    it "is expected to respond with successful when the user had MFA enabled but was disabled" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => "true")
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value => "email")

        new_user.settings.update(:name => "mfa_enabled", :value => false) # Now it is disabled

        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_successful

        # custom examples
        expect(response_data).to have_key("default_path")
        expect(response_data["default_path"]).to be_nil
    end

    it "is expected to respond with successful when MFA fields are present but are invalid, so is consider as not configured" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => Faker::Lorem.word)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value => Faker::Lorem.word)

        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_successful
    end

    it "is expected to respond with successful when MFA is enabled but the method is invalid so MFA should not have been triggered" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => "true")
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value => Faker::Lorem.word)

        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_successful
    end
end

RSpec.describe "POST:/login.json", type: :request do
    include_context "request user authentication"
    it "is expected to redirect to '/' route when the user is already logged" do
        post "/login.json", params: { user: { email: "", password: "" } }
        expect(response).to redirect_to("/")
    end
end
