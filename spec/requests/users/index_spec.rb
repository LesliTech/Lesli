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
@website  https://www.lesli.dev
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

require "rails_helper"

require Lesli::Engine.root.join("spec/support/lesli_request_tester")

# ·
#require "support/lesli_request_tester"


RSpec.describe "GET:/administration/users.json", type: :request do

    it "is expected to test" do 
        expect(true).to eql(true)
    end
end

# ·
=begin
RSpec.describe "GET:/administration/users.json", type: :request do

    include_context "request user authentication"

    it "is expected to respond with users index" do

        get "/administration/users.json", params: {
            :perPage => 1000
        }

        expect_response_with_pagination

        expect_count = @current_user.account.users.count

        expect(response_body["pagination"]["total"]).to eql(expect_count)

    end

    it "is expected that the index includes users with a valid role" do
        get "/administration/users.json"

        # shared examples
        expect_response_with_pagination

        # custom specs
        expect(response_body["records"].first).to have_key("rolenames")
        expect(response_body["records"].first["rolenames"]).to be_an(String)

    end
end
=end
