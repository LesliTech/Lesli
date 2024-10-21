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
require Lesli::Engine.root.join("lib/rspec/testers/request")

# ·
RSpec.describe Lesli::AboutsController, type: :request do

    include_context "request user authentication"

    it "is expected to list installed engines" do

        get("#{LESLI_ENGINE_MOUNTED_PATH}/about.json")

        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_body).to be_an(Array)
        expect(response_body.length).to be >= 1

        expect(response_body.first).to have_key("name")
        expect(response_body.first).to have_key("code")
        expect(response_body.first).to have_key("path")
        expect(response_body.first).to have_key("build")
        expect(response_body.first).to have_key("version")

        expect(response_body.first["name"]).to be_a(String)
        expect(response_body.first["code"]).to be_a(String)
        expect(response_body.first["path"]).to be_a(String)
        expect(response_body.first["build"]).to be_a(String)
        expect(response_body.first["version"]).to be_a(String)

        expect(response_body.first["name"]).to eql(Lesli.to_s)
        expect(response_body.first["code"]).to eql(Lesli.to_s.underscore)
        expect(response_body.first["path"]).to eql(Lesli::Engine.routes.find_script_name({}))
        expect(response_body.first["build"]).to eql(Lesli::BUILD)
        expect(response_body.first["version"]).to eql(Lesli::VERSION)
    end
end
