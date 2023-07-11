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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end


# · include helpers, configuration & initializers for request tests
require "support/lesli_request_tester"


# ·
RSpec.describe "POST:/administration/users.json", type: :request  do

    include_context "request user authentication"

    it "is expected to create a user through the administration area" do
        user = FactoryBot.attributes_for(:user)

        user[:account_id] = nil # by default the method creates an account for the user, so we do not need it

        post("/administration/users.json", params: {
            user: user
        })

        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_body["id"]).to be_a(Numeric)
        expect(response_body["active"]).to eql(true)
        expect(response_body["email"]).to eql(user[:email])
        #expect(response_body["alias"]).to not_in(["", nil])
        expect(response_body["first_name"]).to eql(user[:first_name])
        expect(response_body["last_name"]).to eql(user[:last_name])
        expect(response_body["telephone"]).to eql(user[:telephone])
    end


    it "is expected to assign limited role to user" do
        user = FactoryBot.attributes_for(:user)

        post("/administration/users.json", params: {
            user: user
        })

        # shared examples
        expect_response_with_successful

        # custom specs
        roles = User.find(response_body["id"]).roles
        expect(roles.find { |role| role[:name] == "limited" }).to_not be_nil
    end


    it "is expected to assign the role sent in the user params" do
        user = FactoryBot.attributes_for(:user)
        user[:roles_id] = Role.find_by(name: "sysadmin").id

        post("/administration/users.json", params: {
            user: user
        })

        # shared examples
        expect_response_with_successful

        # custom specs
        user_roles = User.find_by_id(response_body["id"]).roles
        expect(user_roles.find { |role| role.id == user[:roles_id] }).to_not be_nil
    end


    it "is expected to not create a user that already exists" do
        user = FactoryBot.attributes_for(:user)

        post("/administration/users.json", params: {
            user: user
        })

        post("/administration/users.json", params: {
            user: user
        })

        # shared examples
        expect_response_with_error

    end


    it "is expected to not create a user with nil email" do
        user = FactoryBot.attributes_for(:user)
        user[:email] = nil

        post("/administration/users.json", params: {
            user: user
        })

        # shared examples
        expect_response_with_error
    end


    it "is expected to not create a user with an empty email" do
        user = FactoryBot.attributes_for(:user)
        user[:email] = ""

        post("/administration/users.json", params: {
            user: user
        })

        # shared examples
        expect_response_with_error
    end
end
