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
RSpec.describe "POST:/feedback.json", type: :request  do

    #include_context "request user authentication"

    it "is expected to create a user through the administration area" do
        feedback = FactoryBot.attributes_for(:feedback)

        # user[:account_id] = nil # by default the method creates an account for the user, so we do not need it

        post("/feedback.json", params: {
            feedback: feedback
        })

        # # shared examples
        expect_response_with_successful

        # # custom specs
        # expect(response_body["id"]).to be_a(Numeric)
        # expect(response_body["active"]).to eql(true)
        # expect(response_body["email"]).to eql(user[:email])
        # #expect(response_body["alias"]).to not_in(["", nil])
        # expect(response_body["first_name"]).to eql(user[:first_name])
        # expect(response_body["last_name"]).to eql(user[:last_name])
        # expect(response_body["telephone"]).to eql(user[:telephone])
    end
end
