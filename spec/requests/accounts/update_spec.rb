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
RSpec.describe "PUT:/lesli/account.json", type: :request do
    include_context "request user authentication"

    it "is expected to update the account information as a whole" do
        new_account_info = FactoryBot.attributes_for(:account)

        put("#{ENGINE_MOUNTED_PATH}/account.json", params: { account: new_account_info })

        # shared examples
        expect_response_with_successful

        # custom expects
        expect(response_body["id"]).to eq(@current_user.account.id)
        expect(response_body["company_name"]).to eq(new_account_info[:company_name])
        expect(response_body["company_name_legal"]).to eq(new_account_info[:company_name_legal])
        expect(response_body["company_tag_line"]).to eq(new_account_info[:company_tag_line])
        # expect(response_body["country"]).to eq(new_account_info[:country])
        expect(response_body["city"]).to eq(new_account_info[:city])
        expect(response_body["postal_code"]).to eq(new_account_info[:postal_code])
        expect(response_body["address"]).to eq(new_account_info[:address])
        expect(response_body["region"]).to eq(new_account_info[:region])
        expect(response_body["website"]).to eq(new_account_info[:website])
        expect(response_body["phone_number_1"]).to eq(new_account_info[:phone_number_1])
        expect(response_body["public_email"]).to eq(new_account_info[:public_email])
        expect(response_body["github"]).to eq(new_account_info[:github])
        expect(response_body["twitter"]).to eq(new_account_info[:twitter])
        expect(response_body["youtube"]).to eq(new_account_info[:youtube])
        expect(response_body["linkedin"]).to eq(new_account_info[:linkedin])
        expect(response_body["facebook"]).to eq(new_account_info[:facebook])
        expect(response_body["status"]).to eq(new_account_info[:status])
    end

    it "is expected not to allow empty/null company name" do

        put("#{ENGINE_MOUNTED_PATH}/account.json", params: { account: { company_name: "" }})

        # shared examples
        expect_response_with_error
    end

end
