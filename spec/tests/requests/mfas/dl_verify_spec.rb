=begin

Copyright (c) 2022, all rights reserved.

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


require "lesli_request_helper"
=begin
RSpec.describe "Tests for DeutscheLeibrenten", :if => defined?(DeutscheLeibrenten) do
    describe "POST:/mfa/verify.json", type: :request  do
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
            mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => "true")
            mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value => "email")
     
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
            mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => "true")
            mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value => "email")
     
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
            mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => "true")
            mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value => "email")
     
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
            mfa_enabled = new_user.settings.find_or_create_by(:name => "mfa_enabled", :value => "true")
            mfa_method = new_user.settings.find_or_create_by(:name => "mfa_method", :value => "email")
     
            # do request
            post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }
    
            # shared examples
            expect_json_response_successful
    
            # Get the key (ENCRYPTED EMAIL)
            separted_default_path = response_data["default_path"].split("?key=")
            encrypted_email = separted_default_path[1]
    
            # disable MFA manually :mmmmmmm:
            new_user.settings.update!(:name => "mfa_enabled", :value => "false") # Now it is disabled
    
            # do request
            post "/mfa/verify.json?key=#{encrypted_email}", params: { mfa:{ t: ""} }
    
            # shared examples
            expect_json_response_error
        end
    end
end
=end
