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
RSpec.describe "GET:/confirmation.json", type: :request do

    it "is expected to create and confirm a new account" do

        email = Faker::Internet.email
        password = Faker::Internet.password(min_length: 8)

        post("/", params: { 
            email: email,
            password: password,
            password_confirmation: password
        })

        # check user creation in the database 
        current_user = Lesli::User.find_by(:email => email)

        token = current_user.confirmation_token

        expect(token).to be_a(String)
        expect(token.size).to be > 1

        expect(current_user.confirmed?).to be(false)

        # Confirm the account
        get("/confirmation?confirmation_token=#{token}")

        # check for a successful response
        expect(response).to have_http_status(:success)

        # Here I should test to find a paragraph with a successful message
        # <p>Confirmation successfully</p>
        # response.body

        current_user.reload

        expect(current_user.confirmed?).to be(true)
        expect(current_user.confirmation_token).to be(nil)
        expect(current_user.confirmed_at).not_to be(nil)
    end

    it "is expected to fail when confirmed a not valid token" do

        get("/confirmation?confirmation_token=1234567890")

        expect(response).to have_http_status(:success)

        # Here I should test to find a paragraph with an error notification
        # <div class="notification is-danger">
        #   I18n.t("core.users/confirmations.messages_warning_invalid_token")
        # </div>
        # response.body
    end

    it "is expected to fail when confirmed a nil token" do

        get("/confirmation?confirmation_token=")

        expect(response).to have_http_status(:success)

        # Here I should test to find a paragraph with an error notification
        # <div class="notification is-danger">
        #   I18n.t("core.users/confirmations.messages_warning_invalid_token")
        # </div>
        # response.body
    end

    it "is expected to fail when confirmed undefined token" do

        get("/confirmation")

        expect(response).to have_http_status(:success)

        # Here I should test to find a paragraph with an error notification
        # <div class="notification is-danger">
        #   I18n.t("core.users/confirmations.messages_warning_invalid_token")
        # </div>
        # response.body
    end
end
