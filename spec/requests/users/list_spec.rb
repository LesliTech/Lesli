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
require Lesli::Engine.root.join("spec/support/testers/request")

ENGINE_MOUNTED_PATH ||= Lesli::Engine.routes.find_script_name({})

ENGINE_MOUNTED_PATH = "" if ENGINE_MOUNTED_PATH == "/"


# ·
RSpec.describe "GET:#{ENGINE_MOUNTED_PATH}/users/list.json", type: :request do
    include_context "request user authentication"

    it "is expected to list users" do

        get("#{ENGINE_MOUNTED_PATH}/users/list.json")

        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_body).to be_an(Array)
        expect(response_body.length).to be >= 1

        expect(response_body.first).to have_key("id")
        expect(response_body.first["id"]).to be_a(Numeric)
        expect(response_body.first["id"]).to be >= 1

        expect(response_body.first).to have_key("email")
        expect(response_body.first["email"]).to be_a(String)

        expect(response_body.first).to have_key("name")
        expect(response_body.first["name"]).to be_a(String)

        expect(response_body.first).to have_key("alias")
        expect(response_body.first["alias"]).to be_a(String)
    end
end
