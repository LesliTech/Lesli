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
require Lesli::Engine.root.join("spec/support/lesli_request_tester")


ENGINE_MOUNTED_PATH = Lesli::Engine.routes.find_script_name({})


# · 
RSpec.describe "GET:/lesli/account.json", type: :request do
    include_context "request user authentication"

    it "is expected pass share example response with successful" do

        get("#{ENGINE_MOUNTED_PATH}/account.json")

        #share examples
        expect_response_with_successful

        #validate response hash not null and keywords
        expect(response_body).not_to be_nil
        expect(response_body).to be_an(Hash)
        expect(response_body).to have_key("id")
        expect(response_body).to have_key("status")
        expect(response_body).to have_key("company_name")
        expect(response_body).to have_key("company_name_legal")
        expect(response_body).to have_key("company_tagline")
        expect(response_body).to have_key("country")
        expect(response_body).to have_key("address")
        expect(response_body).to have_key("region")
        expect(response_body).to have_key("website")
        expect(response_body).to have_key("phone_number_1")
        expect(response_body).to have_key("phone_number_2")
        expect(response_body).to have_key("phone_number_3")
        expect(response_body).to have_key("phone_number_4")
        expect(response_body).to have_key("public_email")
        expect(response_body).to have_key("github")
        expect(response_body).to have_key("twitter")
        expect(response_body).to have_key("youtube")
        expect(response_body).to have_key("linkedin")
        expect(response_body).to have_key("facebook")
        expect(response_body).to have_key("created_at")
        expect(response_body).to have_key("updated_at")
        expect(response_body).to have_key("user_id")
        expect(response_body).to have_key("city")
        expect(response_body).to have_key("postal_code")
    end


    it "is expected to have current user account values" do

        get("#{ENGINE_MOUNTED_PATH}/account.json")

        #share examples
        expect_response_with_successful

        #validate keyvalues values
        expect(response_body["id"]).to eq(@current_user.account.id)
        expect(response_body["status"]).to eq(@current_user.account.status)
        expect(response_body["company_name"]).to eq(@current_user.account.company_name)
        expect(response_body["company_name_legal"]).to eq(@current_user.account.company_name_legal)
        expect(response_body["company_tagline"]).to eq(@current_user.account.company_tagline)
        expect(response_body["country"]).to eq(@current_user.account.country)
        expect(response_body["address"]).to eq(@current_user.account.address)
        expect(response_body["region"]).to eq(@current_user.account.region)
        expect(response_body["website"]).to eq(@current_user.account.website)
        expect(response_body["phone_number_1"]).to eq(@current_user.account.phone_number_1)
        expect(response_body["phone_number_2"]).to eq(@current_user.account.phone_number_2)
        expect(response_body["phone_number_3"]).to eq(@current_user.account.phone_number_3)
        expect(response_body["phone_number_4"]).to eq(@current_user.account.phone_number_4)
        expect(response_body["public_email"]).to eq(@current_user.account.public_email)
        expect(response_body["github"]).to eq(@current_user.account.github)
        expect(response_body["twitter"]).to eq(@current_user.account.twitter)
        expect(response_body["youtube"]).to eq(@current_user.account.youtube)
        expect(response_body["linkedin"]).to eq(@current_user.account.linkedin)
        expect(response_body["facebook"]).to eq(@current_user.account.facebook)
        expect(response_body["user_id"]).to eq(@current_user.account.user_id)
        expect(response_body["city"]).to eq(@current_user.account.city)
        expect(response_body["postal_code"]).to eq(@current_user.account.postal_code)
    end
end
