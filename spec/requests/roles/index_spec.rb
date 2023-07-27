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


# ·
require "support/lesli_request_tester"


# ·
RSpec.describe "GET:/administration/roles.json", type: :request do

    include_context "request user authentication"

    it "is expected to respond with an index of roles" do

        role = FactoryBot.create(:role)

        user_role_level_max = @current_user.roles.map(&:object_level_permission).max()

        total = @current_user.account.roles.where("roles.object_level_permission < ?", user_role_level_max).count

        get("/administration/roles.json")

        # shared examples
        expect_response_with_pagination

        # custom specs
        expect(response_body["pagination"]["total"]).to eql(total)

    end
end