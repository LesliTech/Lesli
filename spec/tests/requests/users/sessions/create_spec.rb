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
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value_boolean => true)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value_string => "email")

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
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value_boolean => false)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value_string => "email")

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
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value_boolean => true)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value_string => "email")

        new_user.settings.update(:name => "mfa_enabled", :value_string => false) # Now it is disabled

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
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value_boolean => Faker::Lorem.word)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value_string => Faker::Lorem.word)

        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_error
    end

    it "is expected to respond with error when MFA is enabled but the method is invalid" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value_boolean => true)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value_string => Faker::Lorem.word)

        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_error
    end

    it "is expected to return with error when the key query param exists but is invalid" do

        # do request
        post "/mfa/verify.json?key=", params: { mfa: { t: "" } }

        # shared examples
        expect_json_response_error
    end

    it "is expected to return with successful when the MFA token is valid" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value_boolean => true)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value_string => "email")
 
        # do first request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_successful

        # Get the key (ENCRYPTED EMAIL)
        separted_default_path = response_data["default_path"].split("?key=")
        encrypted_email = separted_default_path[1]

        # Generate valid token for the current user
        access_code = new_user.access_codes.new( { token_type: "mfa" } )
        raw, enc = Devise.token_generator.generate(User::AccessCode.first.class, :token)
        access_code.token = enc
        access_code.save!

        # do second request
        post "/mfa/verify.json?key=#{encrypted_email}", params: { mfa: { t: raw } }

        # shared examples
        expect_json_response_successful

        # custom examples
        expect(response_data).to have_key("default_path")
    end

    it "is expected to return with error when the MFA token is valid but belongs to another user" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value_boolean => true)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value_string => "email")
 
        # do first request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_successful

        # Get the key (ENCRYPTED EMAIL)
        separted_default_path = response_data["default_path"].split("?key=")
        encrypted_email = separted_default_path[1]

        # Generate valid token for another user, so should return with error
        another_user = FactoryBot.create(:user)
        access_code = another_user.access_codes.new( { token_type: "mfa" } )
        raw, enc = Devise.token_generator.generate(User::AccessCode.first.class, :token)
        access_code.token = enc
        access_code.save!

        # do second request
        post "/login.json?key=#{encrypted_email}", params: { mfa: { t: raw } } # TOKEN THAT BELONGS TO ANOTHER USER

        # shared examples
        expect_json_response_error
    end

    it "is expected to return with error when the MFA confirmation token is invalid" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value_boolean => true)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value_string => "email")
 
        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_successful

        # Get the key (ENCRYPTED EMAIL)
        separted_default_path = response_data["default_path"].split("?key=")
        encrypted_email = separted_default_path[1]

        # do request
        post "/login.json?key=#{encrypted_email}", params: { mfa:{ t: ""} } # INVALID TOKEN

        # shared examples
        expect_json_response_error

        # do request
        post "/login.json?key=#{encrypted_email}" # NO TOKEN

        # shared examples
        expect_json_response_error
    end

    it "is expected to return with error when the MFA token was generated but the funtionality was disabled manually" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value_boolean => true)
        mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value_string => "email")
 
        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_json_response_successful

        # Get the key (ENCRYPTED EMAIL)
        separted_default_path = response_data["default_path"].split("?key=")
        encrypted_email = separted_default_path[1]

        # disable MFA manually :mmmmmmm:
        new_user.settings.update!(:name => "mfa_enabled", :value_boolean => false) # Now it is disabled

        # do request
        post "/mfa/verify.json?key=#{encrypted_email}", params: { mfa:{ t: ""} }

        # shared examples
        expect_json_response_error
    end
end

RSpec.describe "POST:/login.json", type: :request do
    include_context "request user authentication"
    it "is expected to redirect to '/' route when the user is already logged" do
        post "/login.json", params: { user: { email: "", password: "" } }
        expect(response).to redirect_to("/")
    end
end
