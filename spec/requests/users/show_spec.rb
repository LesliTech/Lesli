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
RSpec.describe "GET:/administration/users/:id.json", type: :request do

    include_context "request user authentication"

    it "is expected to respond with the first user created" do
        user = FactoryBot.create(:user)

        get("/administration/users/#{user.id}.json")

        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_body["id"]).to eql(user.id)
        expect(response_body["email"]).to eql(user.email)
        expect(response_body["alias"]).to eql(user.alias)
        expect(response_body["active"]).to eql(user.active)
        expect(response_body["full_name"]).to eql(user.full_name)
    end


    it "is expected to respond with the development user" do

        get("/administration/users/#{@current_user.id}.json")

        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_body["id"]).to eql(@current_user.id)
        expect(response_body["email"]).to eql(@current_user.email)
        expect(response_body["alias"]).to eql(@current_user.alias)
        expect(response_body["active"]).to eql(@current_user.active)
        expect(response_body["full_name"]).to eql(@current_user.full_name)
    end

=begin
    # To enable this test I have to active the user authorization methods
    it "is expected to respond with unauthorized when is using limited user" do
        limited_user = FactoryBot.create(:user, role_name: "limited")
        sign_in(limited_user)
        get("/administration/account.json")
        expect_response_with_unauthorized
    end
=end
end
