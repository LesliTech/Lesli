=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end


# ·
require "rails_helper"
require Lesli::RSpec.testers_request


# ·
RSpec.describe "POST:/login.json", type: :request do

    # creates a new user for every test
    before :each do
        @user = FactoryBot.create(:lesli_user)
    end


    it "is expected to respond with successful standard json response" do

        post("/login.json", params: { 
            user: { 
                email: @user.email, 
                password: @user.password 
            }
        })

        expect_response_with_successful
        expect(response_body).to have_key("default_path")
    end

    it "is expected to respond with error standard json response" do

        post("/login.json", params: { 
            user: { 
                email: "", 
                password: "" 
            }
        })

        # shared examples
        expect_response_with_error
        expect(response_body["message"]).to eql(I18n.t("core.users/sessions.invalid_credentials"))
    end

    it "is expected to respond with error when the credentials are invalid" do

        post("/login.json", params: { 
            user: { 
                email: @user.email, 
                password: "wrong password"
            }
        })

        # shared examples
        expect_response_with_error
        expect(response_body["message"]).to eql(I18n.t("core.users/sessions.invalid_credentials"))

        #expect(response_body)
    end

    it "is expected to respond with error when params are not present" do
        # do request
        post("/login.json")

        # shared examples
        expect_response_with_error
        expect(response_body["message"]).to eql(I18n.t("core.users/sessions.invalid_credentials"))
    end
=begin

    # Tests for MFA integration

    it "is expected to respond with successfull and default path to /mfa view when a user has MFA enabled" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        new_user.settings.upsert({ value: true, name:"mfa_enabled"}, unique_by: [:users_id, :name])
        new_user.settings.upsert({ value: "email", name:"mfa_method"}, unique_by: [:users_id, :name])


        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_response_with_successful

        # custom examples
        expect(response_body).to have_key("default_path")
        expect(response_body["default_path"]).to be_a(String)
        expect(response_body["default_path"]).to eql("mfa")
    end

    it "is expected to respond with successfull and do 'normal' login when MFA fields exists but it is disabled" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        new_user.settings.upsert({ value: false, name:"mfa_enabled"}, unique_by: [:users_id, :name])
        new_user.settings.upsert({ value: "email", name:"mfa_method"}, unique_by: [:users_id, :name])

        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_response_with_successful

        # custom examples
        expect(response_body).to have_key("default_path")
    end

    it "is expected to respond with successful when the user had MFA enabled but was disabled" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        new_user.settings.upsert({ value: true, name:"mfa_enabled"}, unique_by: [:users_id, :name])
        new_user.settings.upsert({ value: "email", name:"mfa_method"}, unique_by: [:users_id, :name])

        new_user.settings.find_by(name: "mfa_enabled").update(:value => false) # Now it is disabled

        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_response_with_successful

        # custom examples
        expect(response_body).to have_key("default_path")
    end

    it "is expected to respond with successful when MFA fields are present but are invalid, so is consider as not configured" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        new_user.settings.upsert({ value: Faker::Lorem.word, name:"mfa_enabled"}, unique_by: [:users_id, :name])
        new_user.settings.upsert({ value: Faker::Lorem.word, name:"mfa_method"}, unique_by: [:users_id, :name])

        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_response_with_successful
    end

    it "is expected to respond with successful when MFA is enabled but the method is invalid so MFA should not have been triggered" do
        # create the new user
        new_user = FactoryBot.create(:user)

        # enable MFA for the new user and its method
        new_user.settings.upsert({ value: true, name:"mfa_enabled"}, unique_by: [:users_id, :name])
        new_user.settings.upsert({ value: Faker::Lorem.word, name:"mfa_method"}, unique_by: [:users_id, :name])

        # do request
        post "/login.json", params: { user: { email: new_user.email, password: new_user.password } }

        # shared examples
        expect_response_with_successful
    end
=end
end
