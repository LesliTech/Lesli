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

    # Tests since MFA integration

    it "is expected to respond with successfull and redirect to enter_code view when a user has MFA enabled" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => true)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value => "email")

        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_successful

        # custom examples
        expect(response_data).to have_key("default_path") # this path should be something like /mfa/enter_code?key=ENCRYPTED_EMAIL
        expect(response_data["default_path"]).to be_a(String)
        expect(response_data["default_path"]).to include("/mfa/enter_code?key=")
    end

    it "is expected to respond with successfull and do 'normal' login when MFA fields are created but it is disabled" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => false) # mfa_enabled="f"
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
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => true)
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

    it "is expected to respond with error when MFA is enabled but the method is invalid" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => true)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value => Faker::Lorem.word)

        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_error
    end

    it "is expected to return with error when the key query param exists but is invalid" do

        # do request
        post "/login.json?key=" # NO TOKEN

        # shared examples
        expect_json_response_error
    end

    it "is expected to return with error when the MFA confirmation token is invalid" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => true)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value => "email")
 
        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_successful

        # Get the key (ENCRYPTED EMAIL)
        separted_default_path = response_data["default_path"].split("?key=")
        encrypted_email = separted_default_path[1]

        # do request
        post "/login.json?key=#{encrypted_email}", params: { user:{ mfa_token: ""} } # INVALID TOKEN

        # shared examples
        expect_json_response_error

        # do request
        post "/login.json?key=#{encrypted_email}" # NO TOKEN

        # shared examples
        expect_json_response_error
    end

    it "is expected to return with error when the MFA token has been generated but was disabled manually" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => true)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value => "email")
 
        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_successful

        # Get the key (ENCRYPTED EMAIL)
        separted_default_path = response_data["default_path"].split("?key=")
        encrypted_email = separted_default_path[1]

        # disable MFA manually :mmmmmmm:
        new_user.settings.update(:name => "mfa_enabled", :value => false) # Now it is disabled

        # do request
        post "/login.json?key=#{encrypted_email}", params: { user:{ mfa_token: ""} } # INVALID TOKEN

        # shared examples
        expect_json_response_successful

        # custom examples
        expect(response_data).to have_key("default_path")
        expect(response_data["default_path"]).to be_nil
    end
end

RSpec.describe "POST:/login.json", type: :request do
    include_context "request user authentication"
    it "is expected to redirect to '/' route when the user is already logged" do
        post "/login.json", params: { user: { email: "", password: "" } }
        expect(response).to redirect_to("/")
    end
end
